import secrets
from rest_framework import serializers
from .models import User, Role, ShopSettings, Shift, BUSINESS_CATEGORY_CHOICES, CURRENCY_CHOICES
from .phone_utils import validate_myanmar_phone
from inventory.models import Location

# ၁။ Role အတွက် Serializer
class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = '__all__'


# Shift (အလုပ်ချိန်) CRUD
class ShiftSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shift
        fields = ['id', 'name', 'start_time', 'end_time', 'is_active']

# ၂။ Login ဝင်ထားသူ၏ Profile အတွက် Serializer (includes phone_number and outlet for session)
# role_obj/primary_outlet ကို safe ယူသည် – ဆက်စပ်စာမျက်နှာ ပျက်သွားရင် 500 မဖြစ်အောင်
class UserSerializer(serializers.ModelSerializer):
    role_name = serializers.SerializerMethodField()
    role_obj = serializers.SerializerMethodField()
    primary_outlet = serializers.SerializerMethodField()
    primary_location = serializers.SerializerMethodField()
    current_location = serializers.SerializerMethodField()
    assigned_locations_list = serializers.SerializerMethodField()
    primary_outlet_info = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id', 'username', 'email', 'phone_number', 'role_obj', 'role_name', 'is_staff',
            'assignment_type', 'primary_location', 'primary_outlet', 'primary_outlet_info',
            'current_location', 'assigned_locations_list', 'requires_password_change'
        )

    def get_role_name(self, obj):
        try:
            ro = getattr(obj, 'role_obj', None)
            return getattr(ro, 'name', None) or '' if ro else ''
        except Exception:
            return ''

    def get_role_obj(self, obj):
        try:
            return getattr(obj, 'role_obj_id', None)
        except Exception:
            return None

    def get_primary_outlet(self, obj):
        try:
            return getattr(obj, 'primary_outlet_id', None)
        except Exception:
            return None

    def get_primary_location(self, obj):
        try:
            return getattr(obj, 'primary_location_id', None)
        except Exception:
            return None

    def get_primary_outlet_info(self, obj):
        try:
            if getattr(obj, 'primary_outlet_id', None):
                po = getattr(obj, 'primary_outlet', None)
                if po is not None:
                    return {'id': getattr(po, 'id', None), 'name': getattr(po, 'name', '') or '', 'code': getattr(po, 'code', '') or ''}
        except Exception:
            pass
        return None

    def get_current_location(self, obj):
        """ယနေ့အလုပ်လုပ်မည့်ဆိုင် (StaffSession မှ ယူသည်)"""
        try:
            session = getattr(obj, 'work_sessions', None)
            if session:
                session = session.filter(is_active=True).first()
            if session and getattr(session, 'location', None):
                loc = session.location
                return {'id': getattr(loc, 'id', None), 'name': getattr(loc, 'name', '') or ''}
            if getattr(obj, 'primary_location', None):
                loc = obj.primary_location
                return {'id': getattr(loc, 'id', None), 'name': getattr(loc, 'name', '') or ''}
            al = getattr(obj, 'assigned_locations', None)
            if al:
                loc = al.filter(is_sale_location=True).first()
                if loc:
                    return {'id': getattr(loc, 'id', None), 'name': getattr(loc, 'name', '') or ''}
        except Exception:
            pass
        return None

    def get_assigned_locations_list(self, obj):
        """တာဝန်ကျထားသော ဆိုင်များ"""
        try:
            al = getattr(obj, 'assigned_locations', None)
            if al:
                return [{'id': getattr(loc, 'id', None), 'name': getattr(loc, 'name', '') or ''} for loc in al.filter(is_sale_location=True)]
        except Exception:
            pass
        return []


# ၃။ ဝန်ထမ်းစီမံခန့်ခွဲမှုအတွက် Serializer (RBAC + Phone: name, phone, role, outlet)
class EmployeeSerializer(serializers.ModelSerializer):
    role_name = serializers.SerializerMethodField()
    assigned_locations = serializers.PrimaryKeyRelatedField(many=True, queryset=Location.objects.all(), required=False)

    def get_role_name(self, obj):
        return getattr(obj.role_obj, 'name', None) if getattr(obj, 'role_obj', None) else None

    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'phone_number', 'role_obj', 'role_name', 'is_active',
            'assignment_type', 'primary_outlet', 'primary_location', 'assigned_locations', 'password', 'temp_password',
            'first_name', 'last_name', 'requires_password_change'
        ]
        extra_kwargs = {
            'password': {'write_only': True, 'required': False},
            'temp_password': {'read_only': True},
            'username': {'required': False},
            'email': {'required': False},
        }

    def validate_phone_number(self, value):
        if not value:
            return value
        from .phone_utils import validate_myanmar_phone
        is_valid, normalized_or_err = validate_myanmar_phone(value)
        if not is_valid:
            raise serializers.ValidationError(normalized_or_err)
        normalized = normalized_or_err
        qs = User.objects.filter(phone_number=normalized)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError("This phone number is already registered.")
        return normalized

    def validate(self, data):
        from .permissions import is_manager_or_higher
        from inventory.models import Location
        # primary_location ပေးထားရင် primary_outlet ကို ထ location ရဲ့ outlet ကနေ ဖြည့်ပေးမယ် (Frontend က outlet မပို့လျှင်)
        loc = data.get('primary_location') or (self.instance and self.instance.primary_location)
        if loc and not data.get('primary_outlet') and not (self.instance and self.instance.primary_outlet_id):
            loc_obj = loc if isinstance(loc, Location) else Location.objects.filter(pk=loc).select_related('outlet').first()
            if loc_obj and getattr(loc_obj, 'outlet', None):
                data['primary_outlet'] = loc_obj.outlet  # must be Outlet instance, not outlet_id
        role = data.get('role_obj') or (self.instance and self.instance.role_obj)
        if role:
            role_name = getattr(role, 'name', None) or (Role.objects.filter(pk=role).values_list('name', flat=True).first() if role else None) or ''
            r = role_name.lower() if isinstance(role_name, str) else str(role).lower()
            if r not in ('owner', 'admin', 'super_admin') and not data.get('primary_outlet') and not (self.instance and self.instance.primary_outlet_id):
                raise serializers.ValidationError({
                    'primary_outlet': 'Manager, Cashier, and Store Keeper must be assigned to one Outlet.'
                })
        return data

    def create(self, validated_data):
        assigned = validated_data.pop('assigned_locations', [])
        password = validated_data.pop('password', None)
        phone = validated_data.get('phone_number')
        username = (validated_data.get('username') or '').strip()
        if not username and phone:
            validated_data['username'] = 'u' + str(phone)
        elif not username:
            raise serializers.ValidationError({'username': 'Username is required.'})
        if not validated_data.get('email'):
            validated_data['email'] = ''
        user = super().create(validated_data)
        if assigned:
            user.assigned_locations.set(assigned)
        if password:
            user.set_password(password)
            user.temp_password = password
        else:
            default_pw = secrets.token_urlsafe(8)
            user.set_password(default_pw)
            user.temp_password = default_pw
            user.requires_password_change = True
        user.save()
        return user

    def update(self, instance, validated_data):
        assigned = validated_data.pop('assigned_locations', None)
        password = validated_data.pop('password', None)
        instance = super().update(instance, validated_data)
        if assigned is not None:
            instance.assigned_locations.set(assigned)
        if password:
            instance.set_password(password)
            instance.temp_password = password
            instance.save()
        return instance


# ၄။ ဝန်ထမ်း စာရင်းသွင်းခြင်း (Register) - Public - Loyverse-style simplified
# Email and/or Phone, Password, Shop Name. Business Type & unit seeding in Setup Wizard.
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    password_confirm = serializers.CharField(write_only=True)
    email = serializers.EmailField(required=False, allow_blank=True)
    phone_number = serializers.CharField(required=False, allow_blank=True, max_length=20)
    shop_name = serializers.CharField(required=False, allow_blank=True, default='')

    class Meta:
        model = User
        fields = ['email', 'phone_number', 'shop_name', 'password', 'password_confirm']

    def validate_password_confirm(self, value):
        if self.initial_data.get('password') != value:
            raise serializers.ValidationError('Passwords do not match.')
        return value

    def validate_email(self, value):
        v = (value or '').strip().lower()
        if not v:
            return v
        if '@' not in v:
            raise serializers.ValidationError('Enter a valid email address.')
        if User.objects.filter(email__iexact=v).exists():
            raise serializers.ValidationError('This email is already registered. Please login.')
        return v

    def validate_phone_number(self, value):
        raw = (value or '').strip()
        if not raw:
            return raw
        from .phone_utils import validate_myanmar_phone
        ok, result = validate_myanmar_phone(raw, '+95')
        if not ok:
            raise serializers.ValidationError(result)
        if User.objects.filter(phone_number=result).exists():
            raise serializers.ValidationError('This phone number is already registered. Please login.')
        return result

    def validate(self, data):
        data.pop('password_confirm')
        email_val = (data.get('email') or '').strip().lower()
        phone_val = (data.get('phone_number') or '').strip()
        if not email_val and not phone_val:
            raise serializers.ValidationError('Provide at least one: Email or Phone Number.')
        return data

    def create(self, validated_data):
        from django.db import IntegrityError

        password = validated_data.pop('password')
        shop_name = (validated_data.pop('shop_name', '') or '').strip()
        email_val = (validated_data.pop('email', '') or '').strip().lower()
        phone_val = (validated_data.pop('phone_number', '') or '').strip()

        # Username: email if present else phone (Django max 150)
        username = email_val or phone_val
        if len(username) > 150:
            username = username[:147] + '...'

        validated_data['username'] = username
        validated_data['email'] = email_val or ''
        validated_data['phone_number'] = phone_val or None
        validated_data['first_name'] = ''
        validated_data['last_name'] = ''

        is_first_user = User.objects.count() == 0
        if is_first_user:
            owner_role, _ = Role.objects.get_or_create(
                name='owner',
                defaults={'description': 'စနစ်ပိုင်ရှင်'}
            )
            role = owner_role
            is_staff = True
        else:
            default_role, _ = Role.objects.get_or_create(
                name='sale_staff',
                defaults={'description': 'အရောင်းဝန်ထမ်း (ပုံမှန်)'}
            )
            role = default_role
            is_staff = False

        try:
            user = User.objects.create(
                **validated_data,
                role_obj=role,
                is_active=True,
                is_staff=is_staff,
            )
        except IntegrityError as e:
            err = str(e).lower()
            if 'email' in err or 'username' in err or 'unique' in err or 'duplicate' in err:
                raise serializers.ValidationError({
                    'email': 'This email is already registered. Please login.'
                })
            raise serializers.ValidationError({'email': 'This email is already registered. Please login.'})
        user.set_password(password)
        user.save()
        if is_first_user:
            ShopSettings.objects.update_or_create(
                pk=1,
                defaults={'shop_name': shop_name or 'HoBo POS'},
            )
        return user


# ၅။ ဆိုင်ချိန်ညှိချက် (Logo + ဆိုင်အမည်) - Loyverse-style: business_category, currency, setup_wizard_done
class ShopSettingsSerializer(serializers.ModelSerializer):
    logo_url = serializers.SerializerMethodField()
    logo = serializers.ImageField(required=False, allow_null=True)

    class Meta:
        model = ShopSettings
        fields = [
            'shop_name', 'logo', 'logo_url', 'updated_at',
            'business_category', 'currency', 'setup_wizard_done',
            'filter_units_by_business_category',
        ]

    def validate_logo(self, value):
        if value is None:
            return value
        if hasattr(value, 'size') and value.size == 0:
            if self.instance and getattr(self.instance, 'logo', None):
                return self.instance.logo
            return None
        return value

    def get_logo_url(self, obj):
        if not obj or not getattr(obj, 'logo', None):
            return None
        try:
            url = obj.logo.url
            request = self.context.get('request')
            if request:
                url = request.build_absolute_uri(url)
                # Fix localhost without port → ERR_CONNECTION_REFUSED (use MEDIA_BASE_URL)
                import re
                if re.match(r'^https?://localhost(?:/|$)', url):
                    from django.conf import settings
                    base = getattr(settings, 'MEDIA_BASE_URL', None) or getattr(settings, 'SITE_URL', None)
                    if base:
                        path = obj.logo.url if obj.logo.url.startswith('/') else '/' + obj.logo.url
                        url = base.rstrip('/') + path
            return url
        except (ValueError, OSError, AttributeError):
            return None

