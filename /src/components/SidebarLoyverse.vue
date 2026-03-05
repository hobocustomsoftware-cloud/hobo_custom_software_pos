<template>
  <!-- Minimalist POS Sidebar: white, 4 groups (POS, Items, Inventory, Reports) + Settings bottom. Icon-only when collapsed. -->
  <div
    v-show="mobileOpen"
    class="fixed inset-0 bg-black/40 z-[55] lg:hidden"
    aria-hidden="true"
    @click="$emit('update:mobileOpen', false)"
  />
  <aside
    class="sidebar-rail fixed inset-y-0 left-0 z-[60] flex flex-col min-h-screen lg:min-h-0 w-full max-w-[85vw] lg:max-w-none border-r border-[var(--color-border)] lg:relative lg:z-auto lg:translate-x-0 transition-all duration-300 ease-out bg-white"
    style="--sidebar-fixed-width: 280px;"
    :class="mobileOpen ? 'translate-x-0' : '-translate-x-full'"
    @mouseenter="onSidebarMouseEnter"
    @mouseleave="onSidebarMouseLeave"
  >
    <!-- Logo row: compact, icon-only when collapsed -->
    <div class="flex items-center gap-2 p-3 flex-shrink-0 border-b border-[var(--color-border)] min-h-[52px]">
      <div class="w-8 h-8 rounded-lg bg-[var(--color-bg-card)] border border-[var(--color-border)] flex items-center justify-center shrink-0 overflow-hidden">
        <img v-if="shopLogo && !logoError" :src="shopLogo" alt="Logo" class="w-8 h-8 object-contain" @error="logoError = true" />
        <span v-else class="text-xs font-semibold text-[var(--color-primary)]">{{ (shopName || 'POS').slice(0, 2) }}</span>
      </div>
      <span v-show="showLabels" class="text-sm font-semibold text-[var(--color-fg)] truncate">{{ shopName || 'POS' }}</span>
      <button
        type="button"
        class="hidden lg:flex ml-auto p-1.5 rounded text-[var(--color-fg-muted)] hover:bg-[var(--color-bg-light)] hover:text-[var(--color-primary)] transition-colors shrink-0"
        :aria-label="showLabels ? 'Collapse' : 'Expand'"
        @click="$emit('update:collapsed', !collapsed)"
      >
        <ChevronLeft v-if="showLabels" class="w-4 h-4" />
        <ChevronRight v-else class="w-4 h-4" />
      </button>
      <button
        type="button"
        class="lg:hidden p-1.5 rounded text-[var(--color-fg-muted)] hover:bg-[var(--color-bg-card)] ml-auto"
        aria-label="Close"
        @click="$emit('update:mobileOpen', false)"
      >
        <X class="w-4 h-4" />
      </button>
    </div>

    <!-- Nav: only 4 groups + Settings at bottom -->
    <nav class="flex-1 overflow-y-auto py-2 min-h-0">
      <!-- 1. POS -->
      <div class="mb-1">
        <RouterLink to="/sales/pos" class="sidebar-nav-item" :class="{ 'sidebar-nav-item-active': $route.path === '/sales/pos' }">
          <ShoppingCart class="w-4 h-4 shrink-0" stroke-width="2" />
          <span v-show="showLabels">POS</span>
        </RouterLink>
      </div>

      <!-- 2. Dashboard (AI + P&L summary) -->
      <div class="mb-1">
        <RouterLink to="/dashboard" class="sidebar-nav-item" :class="{ 'sidebar-nav-item-active': $route.path === '/dashboard' }">
          <LayoutDashboard class="w-4 h-4 shrink-0" stroke-width="2" />
          <span v-show="showLabels">Dashboard</span>
        </RouterLink>
      </div>

      <!-- 3. Items -->
      <div class="mb-1">
        <button
          type="button"
          class="sidebar-nav-item w-full justify-between"
          :class="{ 'sidebar-nav-item-active': itemsOpen }"
          @click="itemsOpen = !itemsOpen"
        >
          <span class="flex items-center gap-3">
            <Package class="w-4 h-4 shrink-0" stroke-width="2" />
            <span v-show="showLabels">Items</span>
          </span>
          <ChevronDown v-show="showLabels" class="w-4 h-4 shrink-0 transition-transform" :class="itemsOpen ? 'rotate-180' : ''" />
        </button>
        <div v-show="itemsOpen && showLabels" class="ml-3 pl-2 border-l border-[var(--color-border)] space-y-0.5 mt-0.5 mb-1">
          <RouterLink to="/items/list" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Item List</RouterLink>
          <RouterLink to="/items/categories" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Categories</RouterLink>
          <RouterLink to="/items/modifiers" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Modifiers</RouterLink>
          <RouterLink to="/items/discounts" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Discounts</RouterLink>
        </div>
      </div>

      <!-- 4. Inventory -->
      <div class="mb-1">
        <button
          type="button"
          class="sidebar-nav-item w-full justify-between"
          :class="{ 'sidebar-nav-item-active': inventoryOpen }"
          @click="inventoryOpen = !inventoryOpen"
        >
          <span class="flex items-center gap-3">
            <Warehouse class="w-4 h-4 shrink-0" stroke-width="2" />
            <span v-show="showLabels">Inventory</span>
          </span>
          <ChevronDown v-show="showLabels" class="w-4 h-4 shrink-0 transition-transform" :class="inventoryOpen ? 'rotate-180' : ''" />
        </button>
        <div v-show="inventoryOpen && showLabels" class="ml-3 pl-2 border-l border-[var(--color-border)] space-y-0.5 mt-0.5 mb-1">
          <RouterLink to="/shop-locations" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Locations / ဆိုင်ခွဲ</RouterLink>
          <RouterLink to="/inventory/purchase-orders" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Purchase Orders</RouterLink>
          <RouterLink to="/inventory/transfer-orders" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Transfer Orders</RouterLink>
          <RouterLink to="/movements" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Inbound / Outbound</RouterLink>
          <RouterLink to="/inventory/stock-counts" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Stock Counts</RouterLink>
        </div>
      </div>

      <!-- 5. Reports -->
      <div class="mb-1">
        <button
          type="button"
          class="sidebar-nav-item w-full justify-between"
          :class="{ 'sidebar-nav-item-active': reportsOpen }"
          @click="reportsOpen = !reportsOpen"
        >
          <span class="flex items-center gap-3">
            <BarChart2 class="w-4 h-4 shrink-0" stroke-width="2" />
            <span v-show="showLabels">Reports</span>
          </span>
          <ChevronDown v-show="showLabels" class="w-4 h-4 shrink-0 transition-transform" :class="reportsOpen ? 'rotate-180' : ''" />
        </button>
        <div v-show="reportsOpen && showLabels" class="ml-3 pl-2 border-l border-[var(--color-border)] space-y-0.5 mt-0.5 mb-1">
          <RouterLink to="/reports/sales-summary" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Sales Summary</RouterLink>
          <RouterLink to="/reports/receipts" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Receipts</RouterLink>
          <RouterLink to="/reports/shift" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Shift</RouterLink>
        </div>
      </div>

      <!-- 6. Accounting -->
      <div class="mb-1">
        <button
          type="button"
          class="sidebar-nav-item w-full justify-between"
          :class="{ 'sidebar-nav-item-active': accountingOpen }"
          @click="accountingOpen = !accountingOpen"
        >
          <span class="flex items-center gap-3">
            <TrendingUp class="w-4 h-4 shrink-0" stroke-width="2" />
            <span v-show="showLabels">Accounting</span>
          </span>
          <ChevronDown v-show="showLabels" class="w-4 h-4 shrink-0 transition-transform" :class="accountingOpen ? 'rotate-180' : ''" />
        </button>
        <div v-show="accountingOpen && showLabels" class="ml-3 pl-2 border-l border-[var(--color-border)] space-y-0.5 mt-0.5 mb-1">
          <RouterLink to="/accounting/pl" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">P&L Report</RouterLink>
          <RouterLink to="/accounting/expenses" class="sidebar-nav-subitem" active-class="sidebar-nav-item-active">Expenses</RouterLink>
        </div>
      </div>

      <!-- 7. Installation (solar / service) -->
      <div class="mb-1">
        <RouterLink to="/installation" class="sidebar-nav-item" :class="{ 'sidebar-nav-item-active': $route.path.startsWith('/installation') }">
          <Wrench class="w-4 h-4 shrink-0" stroke-width="2" />
          <span v-show="showLabels">Installation</span>
        </RouterLink>
      </div>
    </nav>

    <!-- Settings + Logout at bottom -->
    <div class="p-2 border-t border-[var(--color-border)] flex-shrink-0 bg-white space-y-0.5">
      <RouterLink to="/settings" class="sidebar-nav-item" :class="{ 'sidebar-nav-item-active': $route.path === '/settings' }">
        <Settings class="w-4 h-4 shrink-0" stroke-width="2" />
        <span v-show="showLabels">Settings</span>
      </RouterLink>
      <button
        type="button"
        class="sidebar-nav-item w-full text-left justify-start text-red-600 hover:bg-red-50 hover:text-red-700"
        :class="showLabels ? 'justify-start' : 'justify-center'"
        @click="handleLogout"
      >
        <LogOut class="w-4 h-4 shrink-0" stroke-width="2" />
        <span v-show="showLabels">Logout</span>
      </button>
    </div>
  </aside>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { getLoginPath } from '@/router'
import { useShopSettingsStore } from '@/stores/shopSettings'
import { useAuthStore } from '@/stores/auth'
import {
  BarChart2,
  Package,
  Warehouse,
  ShoppingCart,
  Settings,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  LogOut,
  X,
  LayoutDashboard,
  TrendingUp,
  Wrench,
} from 'lucide-vue-next'

const props = defineProps({
  mobileOpen: { type: Boolean, default: false },
  collapsed: { type: Boolean, default: true },
})
const emit = defineEmits(['update:mobileOpen', 'update:collapsed', 'hover-start', 'hover-end'])

const route = useRoute()
const router = useRouter()
const sidebarHover = ref(false)
const showLabels = computed(() => !props.collapsed || sidebarHover.value)

const reportsOpen = ref(route.path.startsWith('/reports'))
const itemsOpen = ref(route.path.startsWith('/items') || route.path === '/products' || route.path === '/categories')
const inventoryOpen = ref(route.path.startsWith('/inventory') || route.path === '/shop-locations' || route.path === '/movements')
const accountingOpen = ref(route.path.startsWith('/accounting'))

watch(() => route.path, (path) => {
  if (path.startsWith('/reports')) reportsOpen.value = true
  if (path.startsWith('/items') || path === '/products' || path === '/categories') itemsOpen.value = true
  if (path.startsWith('/inventory') || path === '/shop-locations' || path === '/movements') inventoryOpen.value = true
  if (path.startsWith('/accounting')) accountingOpen.value = true
})

function onSidebarMouseEnter() {
  sidebarHover.value = true
  emit('hover-start')
}
function onSidebarMouseLeave() {
  sidebarHover.value = false
  emit('hover-end')
}

const logoError = ref(false)
const shopStore = useShopSettingsStore()
const shopLogo = computed(() => shopStore.logo_url)
const shopName = computed(() => shopStore.displayName)
const authStore = useAuthStore()

function handleLogout() {
  if (confirm('Log out?')) {
    authStore.logout()
    router.push(getLoginPath())
  }
}
</script>

<style scoped>
.sidebar-rail {
  background: #ffffff;
}
/* POS style: comfortable tap targets and readable labels */
.sidebar-nav-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 0.75rem;
  padding: 0.65rem 0.85rem;
  margin: 0 0.35rem;
  border-radius: 10px;
  font-size: 1rem;
  font-weight: 500;
  color: #1a1a1a;
  transition: background 0.15s, color 0.15s;
  text-decoration: none;
  border: none;
  background: transparent;
  width: calc(100% - 0.7rem);
  cursor: pointer;
  text-align: left;
  writing-mode: horizontal-tb;
  white-space: nowrap;
}
.sidebar-nav-item:hover {
  background: var(--color-bg-light);
  color: var(--color-primary);
}
.sidebar-nav-item-active {
  background: var(--color-bg-light);
  color: var(--color-primary);
  font-weight: 600;
}
.sidebar-nav-subitem {
  display: block;
  padding: 0.5rem 0.85rem;
  font-size: 0.95rem;
  color: var(--color-text);
  border-radius: 8px;
  transition: background 0.15s, color 0.15s;
  text-decoration: none;
  writing-mode: horizontal-tb;
}
.sidebar-nav-subitem:hover {
  background: var(--color-bg-light);
  color: var(--color-primary);
}
</style>
