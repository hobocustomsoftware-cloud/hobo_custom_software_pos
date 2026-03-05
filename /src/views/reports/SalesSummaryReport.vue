<template>
  <div class="w-full max-w-6xl mx-auto px-2 sm:px-4">
    <div class="flex flex-wrap items-center justify-between gap-4 mb-4 sm:mb-6">
      <h1 class="text-lg sm:text-xl font-semibold text-[var(--color-fg)]">Sales Summary</h1>
      <div class="flex flex-wrap items-center gap-2">
        <select v-model="filterOutletId" class="min-h-[40px] px-3 rounded-lg border border-[var(--color-border)] text-sm bg-white text-[var(--color-fg)]" @change="doFetch({ force: true })">
          <option value="">ဆိုင်အားလုံး</option>
          <option v-for="o in outlets" :key="o.id" :value="o.id">{{ o.name }}</option>
        </select>
        <label class="text-sm text-[var(--color-fg-muted)]">From</label>
        <input v-model="filterDateFrom" type="date" class="min-h-[40px] px-3 rounded-lg border border-[var(--color-border)] text-sm" @change="doFetch({ force: true })" />
        <label class="text-sm text-[var(--color-fg-muted)]">To</label>
        <input v-model="filterDateTo" type="date" class="min-h-[40px] px-3 rounded-lg border border-[var(--color-border)] text-sm" @change="doFetch({ force: true })" />
        <button
          v-if="!loading"
          type="button"
          class="px-3 py-1.5 text-sm font-medium rounded-lg border border-[var(--color-border)] text-[var(--color-fg)] hover:bg-[var(--color-bg-card)]"
          @click="doFetch({ force: true })"
        >
          Refresh
        </button>
      </div>
    </div>

    <div class="border-b border-[var(--color-border)] mb-4 sm:mb-6">
      <div class="flex gap-1">
        <button
          type="button"
          class="tab-btn"
          :class="{ 'tab-btn-active': activeTab === 'chart' }"
          @click="activeTab = 'chart'"
        >
          <BarChart2 class="w-4 h-4 shrink-0" />
          <span class="hidden sm:inline">Chart view</span>
          <span class="sm:hidden">Chart</span>
        </button>
        <button
          type="button"
          class="tab-btn"
          :class="{ 'tab-btn-active': activeTab === 'table' }"
          @click="activeTab = 'table'"
        >
          <List class="w-4 h-4 shrink-0" />
          <span class="hidden sm:inline">Table view</span>
          <span class="sm:hidden">Table</span>
        </button>
      </div>
    </div>

    <div v-show="activeTab === 'chart'" class="sales-chart-panel bg-white rounded-xl border border-[var(--color-border)] p-4 sm:p-6 shadow-sm min-h-[min(320px,40vh)] sm:min-h-[360px]">
      <div v-if="loading" class="flex items-center justify-center min-h-[200px] sm:min-h-[280px] text-[var(--color-fg-muted)] text-base">Loading...</div>
      <div v-else>
        <p class="text-sm sm:text-base text-[#1a1a1a] mb-2">Sales over time (chart placeholder).</p>
        <div
          v-if="sales.length === 0"
          class="min-h-[200px] sm:min-h-[280px] flex flex-col items-center justify-center rounded-lg bg-[var(--color-bg-card)] border border-[var(--color-border)] text-[#4b5563]"
        >
          <span class="text-4xl mb-3 opacity-60">📊</span>
          <p class="text-sm sm:text-base font-medium">အရောင်းစာရင်း မရှိသေးပါ။</p>
          <p class="text-xs sm:text-sm mt-1">POS မှ ရောင်းချပြီးသည့်အခါ ဒီမှြသမည်။</p>
        </div>
        <div
          v-else
          class="min-h-[200px] sm:min-h-[280px] flex items-center justify-center rounded-lg bg-[var(--color-bg-card)] border border-[var(--color-border)] text-[var(--color-fg-muted)] mt-4"
        >
          Chart view
        </div>
      </div>
    </div>

    <div v-show="activeTab === 'table'" class="sales-table-panel w-full overflow-hidden bg-white rounded-xl border border-[var(--color-border)] shadow-sm min-h-[min(400px,55vh)]">
      <div v-if="loading" class="p-6 sm:p-8 text-center text-[var(--color-fg-muted)] text-sm sm:text-base">Loading...</div>
      <FilterDataTable
        v-else
        ref="tableRef"
        :data="sales"
        :columns="columns"
        :total-count="totalCount"
        :loading="loading"
        title="Sales"
        search-placeholder="Search..."
        :default-page-size="20"
        :light="true"
        empty-message="အရောင်းစာရင်း မရှိသေးပါ။ POS မှ ရောင်းချပြီးသည့်အခါ ဒီမှြသမည်။"
        @fetch-data="doFetch"
      >
        <template #cell-invoice_number="{ value }">
          <span class="font-mono font-medium">#{{ value || '-' }}</span>
        </template>
        <template #cell-total_amount="{ value }">
          <span class="font-medium">{{ value != null ? Math.round(Number(value)).toLocaleString(undefined, { maximumFractionDigits: 0 }) + ' MMK' : '-' }}</span>
        </template>
        <template #cell-status="{ value }">
          <span :class="statusClass(value)" class="px-2 py-1 rounded text-xs font-medium">{{ value }}</span>
        </template>
      </FilterDataTable>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import FilterDataTable from '@/components/FilterDataTable.vue'
import { BarChart2, List } from 'lucide-vue-next'
import api from '@/services/api'

const activeTab = ref('chart')
const tableRef = ref(null)
const sales = ref([])
const totalCount = ref(0)
const loading = ref(true)
const lastFetchAt = ref(0)
const THROTTLE_MS = 3000
const outlets = ref([])
const filterOutletId = ref('')
const filterDateFrom = ref('')
const filterDateTo = ref('')

function getDefaultMonthRange() {
  const d = new Date()
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  filterDateTo.value = `${y}-${m}-${String(d.getDate()).padStart(2, '0')}`
  const first = new Date(y, d.getMonth(), 1)
  filterDateFrom.value = `${first.getFullYear()}-${String(first.getMonth() + 1).padStart(2, '0')}-01`
}

const columns = [
  { key: 'invoice_number', label: 'Invoice No', sortable: true },
  { key: 'created_at', label: 'Date', sortable: true },
  { key: 'customer_name', label: 'Customer', sortable: true },
  { key: 'total_amount', label: 'Total', sortable: true },
  { key: 'status', label: 'Status', sortable: true },
]

function statusClass(s) {
  const st = (s || '').toLowerCase()
  if (st === 'approved') return 'bg-emerald-100 text-emerald-800'
  if (st === 'pending') return 'bg-amber-100 text-amber-800'
  if (st === 'rejected') return 'bg-red-100 text-red-800'
  return 'bg-gray-100 text-gray-700'
}

async function fetchOutlets() {
  try {
    const res = await api.get('core/outlets/')
    outlets.value = res.data ?? []
  } catch {
    outlets.value = []
  }
}

function doFetch(opts = {}) {
  const now = Date.now()
  const force = opts.force === true
  if (!force && now - lastFetchAt.value < THROTTLE_MS) return
  lastFetchAt.value = now
  loading.value = true
  const params = { page: opts.page || 1, page_size: opts.pageSize || 20 }
  if (opts.search) params.search = opts.search
  if (opts.ordering) params.ordering = opts.ordering
  if (filterDateFrom.value) params.date_from = filterDateFrom.value
  if (filterDateTo.value) params.date_to = filterDateTo.value
  if (filterOutletId.value) params.outlet_id = filterOutletId.value
  api.get('invoices/', { params })
    .then((res) => {
      sales.value = res.data.results ?? res.data ?? []
      totalCount.value = res.data.count ?? sales.value.length
    })
    .catch(() => {
      sales.value = []
      totalCount.value = 0
    })
    .finally(() => { loading.value = false })
}

onMounted(() => {
  getDefaultMonthRange()
  fetchOutlets()
  doFetch()
})
</script>

<style scoped>
.tab-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--color-fg-muted);
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  transition: color 0.15s, border-color 0.15s;
}
.tab-btn:hover {
  color: var(--loyverse-blue);
}
.tab-btn-active {
  color: var(--loyverse-blue);
  border-bottom-color: var(--loyverse-blue);
}
</style>
