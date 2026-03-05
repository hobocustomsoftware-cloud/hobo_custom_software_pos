from rest_framework import permissions


def _role_name(user):
    if not user or not user.role_obj:
        return ""
    return user.role_obj.name.lower()


def is_cashier_role(user):
    """Cashier: POS + Sale Request only. No admin, no reports, no cost."""
    return _role_name(user) in ("cashier",)


def is_store_keeper_role(user):
    """Store Keeper: Inbound, Outbound, Internal Transfers within outlet only."""
    r = _role_name(user)
    return r in ("store_keeper", "storekeeper", "store keeper")


def is_manager_or_higher(user):
    """Manager, Admin, Owner: can approve sales, access admin/reports."""
    if not user or not user.is_authenticated:
        return False
    if user.is_superuser:
        return True
    r = _role_name(user)
    return r in ("owner", "admin", "manager", "super_admin")


def is_cashier_or_higher(user):
    """Cashier and above: can use POS and create Sale Requests."""
    if not user or not user.is_authenticated:
        return False
    if user.is_superuser:
        return True
    r = _role_name(user)
    return r in ("owner", "admin", "manager", "super_admin", "cashier", "assistant_manager")


def is_store_keeper_or_higher(user):
    """Store Keeper and above: can manage Inbound, Outbound, Transfers."""
    if not user or not user.is_authenticated:
        return False
    if user.is_superuser:
        return True
    r = _role_name(user)
    return r in ("owner", "admin", "manager", "super_admin", "store_keeper", "storekeeper", "inventory")


class IsSuperAdmin(permissions.BasePermission):
    """Superuser သာ ခွင့်ပြုသည်"""
    def has_permission(self, request, view):
        return request.user and request.user.is_superuser


class IsOwner(permissions.BasePermission):
    """Owner Role ပါဝင်သူ သို့မဟုတ် Superuser သာ ခွင့်ပြုသည်"""
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if user.is_superuser:
            return True
        
        # role_obj ရှိမရှိနှင့် နာမည်ထဲတွင် 'owner' ပါမပါ စစ်ဆေးခြင်း
        return user.role_obj and 'owner' in user.role_obj.name.lower()

class IsAdminOrHigher(permissions.BasePermission):
    """Approval ပေးနိုင်သည့် Role များ (Owner, Admin, Manager)"""
    def has_permission(self, request, view):
        user = request.user
        if not (user and user.is_authenticated):
            return False
        
        # Superuser က အကုန်လုပ်ခွင့်ရှိသည်
        if user.is_superuser:
            return True
        
        if not user.role_obj:
            return False

        role_name = user.role_obj.name.lower()
        allowed_roles = ['owner', 'admin', 'manager', 'super_admin']

        # ၁။ DELETE လုပ်ရန် ကြိုးစားပါက Owner သာ ခွင့်ပြုမည်
        if request.method == 'DELETE':
            return 'owner' in role_name

        # ၂။ ကျန်သည့် Method များ (GET, POST, PUT, PATCH) အတွက် Manager အပါအဝင် ခွင့်ပြုမည်
        return any(r in role_name for r in allowed_roles)

class IsInventoryManagerOrHigher(permissions.BasePermission):
    """Inventory ဆိုင်ရာ လုပ်ပိုင်ခွင့် (Manager, Inventory, Admin, Owner)"""
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if user.is_superuser:
            return True
        
        if user.role_obj:
            role_name = user.role_obj.name.lower()
            # Manager ကို ဒီမှာပါ ထည့်ပေးရပါမယ်
            allowed_roles = ['inventory', 'admin', 'owner', 'manager']
            
            if request.method == 'DELETE':
                return 'owner' in role_name or user.is_superuser
                
            return any(r in role_name for r in allowed_roles)
        return False

class IsStaffOrHigher(permissions.BasePermission):
    """အခြေခံ ဝန်ထမ်းနှင့် အထက် (Login ဝင်နိုင်သူ အားလုံးနီးပါး)"""
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated or not user.is_active:
            return False
        return user.is_superuser or user.role_obj is not None


class IsManagerOrHigher(permissions.BasePermission):
    """Manager, Admin, Owner: full outlet access, approve Sale Requests, admin & reports. Cashier/Store Keeper get 403."""
    def has_permission(self, request, view):
        return is_manager_or_higher(request.user)


class IsCashierOrHigher(permissions.BasePermission):
    """Cashier and above: POS screen, create Sale Requests. Used for staff/items, sales/request, locations."""
    def has_permission(self, request, view):
        return is_cashier_or_higher(request.user)


class IsStoreKeeperOrHigher(permissions.BasePermission):
    """Store Keeper and above: Inbound, Outbound, Internal Transfers within assigned outlet."""
    def has_permission(self, request, view):
        return is_store_keeper_or_higher(request.user)