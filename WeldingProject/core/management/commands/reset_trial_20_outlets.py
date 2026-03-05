"""
Database ရှင်းပြီး Demo Trial တစ်လ + ဆိုင်အရေအတွက် စမ်းလို့ရအောင် setup လုပ်ခြင်း။
တစ်ဆိုင်တည်း သို့မဟုတ် ဆိုင်ခွဲ ၃/၄/၅ ဆိုင် စမ်းချင်သလို --outlets နဲ့ ရွေးနိုင်သည်။

Usage:
  # တစ်ဆိုင်တည်း (Demo လာစမ်းသူအတွက်)
  python manage.py reset_trial_20_outlets --flush --outlets 1

  # ဆိုင်ခွဲ ၃/၄/၅ ဆိုင် စမ်းမယ်
  python manage.py reset_trial_20_outlets --flush --outlets 3
  python manage.py reset_trial_20_outlets --flush --outlets 5

  # ဆိုင် ၂၀ (အရင်လို)
  python manage.py reset_trial_20_outlets --flush --outlets 20

  # Trial စမ်းချင်ရင်: SKIP_LICENSE=false ထားပြီး run ပါ။
  # ပစ္စည်း/ categories ထည့်ချင်ရင်: python manage.py seed_shop_demo --shop general
"""
from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.db import transaction
from django.contrib.auth import get_user_model
from django.utils import timezone

from core.models import Outlet, ShopSettings, Role

User = get_user_model()

OUTLET_CHOICES = [1, 3, 4, 5, 20]  # တစ်ဆိုင်တည်း၊ သုံးလေးငါးဆိုင်၊ သို့မဟုတ် ၂၀


def ensure_user(stdout, style):
    user, created = User.objects.get_or_create(
        username='admin',
        defaults={'email': 'admin@example.com', 'is_staff': True, 'is_superuser': True},
    )
    if created or not user.check_password('admin123'):
        user.set_password('admin123')
        user.save()
    if not getattr(user, 'phone_number', None) or not user.phone_number:
        if hasattr(user, 'phone_number'):
            user.phone_number = '09123456789'
            user.save(update_fields=['phone_number'])
    stdout.write(style.SUCCESS("  User: admin / admin123 (သို့) 09123456789"))
    return user


def ensure_roles(stdout, style):
    for name, desc in [
        ('Owner', 'Full access'),
        ('Manager', 'Manage sales & staff'),
        ('Cashier', 'POS only'),
    ]:
        Role.objects.get_or_create(name=name, defaults={'description': desc})
    owner = Role.objects.get(name='Owner')
    stdout.write(style.SUCCESS("  Roles: Owner, Manager, Cashier"))
    return owner


def ensure_shop_settings_trial(stdout, style):
    """ShopSettings ဖန်တီး/ပြင်ပြီး trial တစ်လ စတင်မယ် (trial_start_date = ယနေ့)"""
    obj = ShopSettings.get_settings()
    obj.trial_start_date = timezone.now()
    obj.shop_name = obj.shop_name or 'HoBo POS Trial'
    obj.setup_wizard_done = True
    obj.save()
    stdout.write(style.SUCCESS("  ShopSettings: trial တစ်လ စတင် (trial_start_date = ယနေ့)"))


def ensure_outlets(stdout, style, num_outlets):
    """ဆိုင်ချုပ် ၁ ခု + ဆိုင်ခွဲ (num_outlets - 1) ခု ဖန်တီးမယ်။ num_outlets=1 ဆို MAIN ပဲ။"""
    main = Outlet.objects.filter(code='MAIN').first()
    if not main:
        main = Outlet.objects.create(
            name="ဆိုင်ချုပ် (Main)",
            code="MAIN",
            is_main_branch=True,
        )
    num_branches = max(0, int(num_outlets) - 1)
    for i in range(1, num_branches + 1):
        code = f"BRANCH_{i:02d}"
        if Outlet.objects.filter(code=code).exists():
            continue
        Outlet.objects.create(
            name=f"ဆိုင်ခွဲ {i}",
            code=code,
            is_main_branch=False,
        )
    for o in Outlet.objects.all():
        o.get_warehouse_location()
        o.get_shopfloor_location()
    count = Outlet.objects.count()
    if num_outlets == 1:
        stdout.write(style.SUCCESS("  Outlets: တစ်ဆိုင်တည်း (ဆိုင်ချုပ် ပဲ)"))
    else:
        stdout.write(style.SUCCESS(f"  Outlets: စုစုပေါင်း {count} ဆိုင် (ဆိုင်ချုပ် + ဆိုင်ခွဲ {num_branches})"))
    return main


class Command(BaseCommand):
    help = 'Database ရှင်းပြီး Demo Trial တစ်လ + ဆိုင်အရေအတွက် (၁/၃/၄/၅/၂၀) စမ်းလို့ရအောင် setup လုပ်ပါ။'

    def add_arguments(self, parser):
        parser.add_argument(
            '--flush',
            action='store_true',
            help='DB flush + migrate + seed_base_units ပြီးမှ trial နဲ့ ဆိုင်များ ထည့်မည်။',
        )
        parser.add_argument(
            '--outlets',
            type=int,
            default=1,
            choices=OUTLET_CHOICES,
            metavar='N',
            help='ဆိုင်အရေအတွက်: 1=တစ်ဆိုင်တည်း, 3/4/5=ဆိုင်ခွဲ သုံးလေးငါး, 20=ဆိုင်၂၀ (default: 1)',
        )

    def handle(self, *args, **options):
        style = self.style
        do_flush = options.get('flush', False)
        num_outlets = options.get('outlets', 1)

        self.stdout.write(style.SUCCESS(f"\n=== Demo Trial တစ်လ + ဆိုင် {num_outlets} ===\n"))

        if do_flush:
            self.stdout.write("DB ရှင်းနေပါတယ် (flush)...")
            call_command('flush', '--noinput')
            call_command('migrate', '--noinput')
            self.stdout.write("Base units ထည့်နေပါတယ်...")
            call_command('seed_base_units')

        with transaction.atomic():
            user = ensure_user(self.stdout, style)
            owner_role = ensure_roles(self.stdout, style)
            ensure_shop_settings_trial(self.stdout, style)
            main = ensure_outlets(self.stdout, style, num_outlets)

            if not getattr(user, 'role_obj_id', None):
                user.role_obj = owner_role
                user.save(update_fields=['role_obj'])
            if not getattr(user, 'primary_outlet_id', None):
                user.primary_outlet = main
                user.save(update_fields=['primary_outlet'])

        self.stdout.write(style.SUCCESS(f"\nပြီးပါပြီ။ Trial တစ်လ စတင်ပြီး ဆိုင် {num_outlets} စမ်းလို့ရပါပြီ။"))
        self.stdout.write("  Login: admin / admin123")
        self.stdout.write("  ပစ္စည်း/ categories ထည့်ချင်ရင်: python manage.py seed_shop_demo --shop general")
