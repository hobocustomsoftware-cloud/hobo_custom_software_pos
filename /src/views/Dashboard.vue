<template>
  <!-- POS-style dashboard: light bg, card grid, Tailwind -->
  <div class="dashboard font-sans text-[var(--color-fg)] max-w-[1600px] mx-auto w-full min-w-0 p-4 sm:p-6">
    <div class="flex flex-wrap justify-between items-center gap-4 mb-6">
      <h1 class="text-xl sm:text-2xl font-bold text-[var(--color-fg)] tracking-tight">Dashboard</h1>
      <select
        v-model="selectedTimeFilter"
        @change="fetchAllData"
        class="rounded-xl border border-[var(--color-border)] bg-white px-4 py-2.5 text-sm font-medium text-[var(--color-fg)] outline-none focus:ring-2 focus:ring-[var(--color-primary)]/30"
      >
        <option v-for="opt in timeOptions" :key="opt" :value="opt">{{ opt }}</option>
      </select>
    </div>

    <div class="grid grid-cols-12 gap-4">
      <!-- Total Revenue -->
      <div class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 overflow-hidden">
        <p class="text-sm font-medium text-[var(--color-fg-muted)] mb-1">Total Revenue</p>
        <p class="text-xl sm:text-2xl font-bold text-[var(--color-fg)] truncate">{{ totalRevenueDisplay }}</p>
        <p class="text-xs text-[var(--color-fg-muted)] mt-1">MMK</p>
      </div>

      <!-- USD Rate -->
      <div class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 overflow-hidden">
        <div class="flex items-center justify-between mb-1">
          <p class="text-sm font-medium text-[var(--color-fg-muted)]">USD Rate</p>
          <span class="flex items-center gap-1.5 text-xs font-semibold text-emerald-600 uppercase tracking-wider">
            <span class="relative flex h-2 w-2">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
            </span>
            Live
          </span>
        </div>
        <p class="text-xl font-bold text-[var(--color-fg)] truncate">{{ usdRateDisplay }}</p>
        <p class="text-xs text-[var(--color-fg-muted)] mt-0.5">MMK per 1 USD</p>
      </div>

      <!-- P&L quick -->
      <div
        class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 flex items-center gap-3 cursor-pointer hover:border-[var(--color-primary)]/50 hover:shadow-md transition-all active:scale-[0.99]"
        @click="router.push('/accounting/pl')"
      >
        <div class="min-w-[48px] min-h-[48px] rounded-xl bg-emerald-50 border border-emerald-200 flex items-center justify-center shrink-0">
          <TrendingUp class="w-6 h-6 text-emerald-600" :stroke-width="1.5" />
        </div>
        <div class="min-w-0">
          <p class="text-sm font-medium text-[var(--color-fg-muted)]">P&L</p>
          <p class="text-lg font-bold text-[var(--color-fg)] truncate">{{ topCards[3].value }}</p>
        </div>
      </div>

      <!-- ဒီနေ့ အရောင်း / P&L -->
      <div
        v-if="todayPl"
        class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 cursor-pointer hover:border-[var(--color-primary)]/50 hover:shadow-md transition-all active:scale-[0.99]"
        @click="router.push('/accounting/pl')"
      >
        <h3 class="text-sm font-medium text-[var(--color-fg-muted)] mb-3">ဒီနေ့အရောင်း / P&L</h3>
        <div class="grid grid-cols-2 gap-2 text-sm">
          <div class="min-w-0"><span class="text-[var(--color-fg-muted)] block truncate text-xs">အရောင်းစုစုပေါင်း</span><p class="font-semibold text-[var(--color-fg)] truncate">{{ formatTodayCurrency(todayPl.total_revenue) }}</p></div>
          <div class="min-w-0"><span class="text-[var(--color-fg-muted)] block truncate text-xs">အမြတ် (Gross)</span><p class="font-semibold text-emerald-600 truncate">{{ formatTodayCurrency(todayPl.gross_profit) }}</p></div>
          <div class="min-w-0"><span class="text-[var(--color-fg-muted)] block truncate text-xs">ကုန်ကျစရိတ်</span><p class="font-semibold text-rose-600 truncate">{{ formatTodayCurrency(todayPl.total_expenses) }}</p></div>
          <div class="min-w-0"><span class="text-[var(--color-fg-muted)] block truncate text-xs">အမြတ်အစွန်း %</span><p class="font-semibold text-[var(--color-fg)] truncate">{{ todayPl.gross_profit_margin_percent || '0' }}%</p></div>
        </div>
      </div>

      <!-- Sales Graph -->
      <div class="col-span-12 md:col-span-6 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 overflow-hidden">
        <h3 class="text-sm font-medium text-[var(--color-fg-muted)] mb-4">Sales Analytics</h3>
        <div class="h-[120px] w-full flex items-end gap-0.5 rounded overflow-hidden bg-[var(--color-bg-light)]">
          <div
            v-for="(v, i) in salesTrendData"
            :key="i"
            class="flex-1 min-w-0 rounded-t bg-[var(--color-primary)] hover:opacity-90 transition-all duration-300"
            :style="{ height: `${Math.max(8, (v / (Math.max(...salesTrendData) || 1)) * 100)}%` }"
            :title="`${v}`"
          />
        </div>
        <p class="text-xs text-[var(--color-fg-muted)] mt-2 uppercase tracking-wider">Last 7 periods</p>
      </div>

      <!-- Installation Jobs -->
      <div
        class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 flex items-center gap-3 cursor-pointer hover:border-[var(--color-primary)]/50 hover:shadow-md transition-all active:scale-[0.99]"
        @click="router.push('/installation/dashboard')"
      >
        <div class="min-w-[48px] min-h-[48px] rounded-xl bg-slate-100 border border-slate-200 flex items-center justify-center shrink-0">
          <Wrench class="w-5 h-5 text-slate-600" :stroke-width="1.5" />
        </div>
        <div class="min-w-0">
          <p class="text-sm font-medium text-[var(--color-fg-muted)]">Installation Jobs</p>
          <p class="text-lg font-bold text-[var(--color-fg)] truncate">{{ installationJobsCount }}</p>
        </div>
      </div>

      <!-- Low Stock -->
      <div
        class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 flex items-center gap-3 cursor-pointer hover:border-amber-300 hover:shadow-md transition-all active:scale-[0.99]"
        @click="router.push('/reports/inventory')"
      >
        <div class="min-w-[48px] min-h-[48px] rounded-xl bg-amber-50 border border-amber-200 flex items-center justify-center shrink-0">
          <AlertTriangle class="w-5 h-5 text-amber-600" :stroke-width="1.5" />
        </div>
        <div class="min-w-0">
          <p class="text-sm font-medium text-[var(--color-fg-muted)]">Low Stock</p>
          <p class="text-lg font-bold text-[var(--color-fg)] truncate">{{ topCards[2].value }}</p>
        </div>
      </div>

      <!-- Active Services -->
      <div class="col-span-12 md:col-span-6 lg:col-span-3 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 flex items-center gap-3">
        <div class="min-w-[48px] min-h-[48px] rounded-xl bg-slate-100 border border-slate-200 flex items-center justify-center shrink-0">
          <Package class="w-5 h-5 text-slate-600" :stroke-width="1.5" />
        </div>
        <div class="min-w-0">
          <p class="text-sm font-medium text-[var(--color-fg-muted)]">Active Services</p>
          <p class="text-lg font-bold text-[var(--color-fg)] truncate">{{ topCards[1].value }}</p>
        </div>
      </div>

      <!-- AI Business Insights -->
      <div class="col-span-12 min-w-0 overflow-hidden">
        <BusinessInsightCard />
      </div>

      <!-- Stock Predictions -->
      <div class="col-span-12 min-w-0 overflow-hidden bg-white rounded-xl border border-[var(--color-border)] shadow-sm">
        <div class="p-5">
          <StockPredictionCard />
        </div>
      </div>

      <!-- Smart Business Insight -->
      <div class="col-span-12 lg:col-span-6 bg-white rounded-xl border border-[var(--color-border)] shadow-sm p-5 min-w-0 overflow-hidden">
        <h3 class="text-sm font-medium text-[var(--color-fg-muted)] mb-3 flex items-center gap-2">
          <span class="p-2 rounded-lg bg-amber-50 border border-amber-200 min-w-[40px] min-h-[40px] flex items-center justify-center">
            <TrendingUp class="w-4 h-4 text-amber-600 shrink-0" :stroke-width="1.5" />
          </span>
          Smart Business Insight
        </h3>
        <div v-if="insightsLoading" class="text-sm text-[var(--color-fg-muted)]">အကြံပြုချက်ယူနေပါသည်...</div>
        <ul v-else class="space-y-2 text-sm text-[var(--color-fg)] leading-relaxed pl-3 border-l-2 border-amber-300">
          <li v-for="(line, idx) in smartInsights" :key="idx">{{ line }}</li>
        </ul>
        <p v-if="!insightsLoading && smartInsights.length === 0" class="text-sm text-[var(--color-fg-muted)]">
          ဒေတာ စုစည်းပြီး နောက်ထပ် အကြံပြုချက်များြသမည်။
        </p>
      </div>

      <!-- Recent Transactions -->
      <div class="col-span-12 lg:col-span-6 bg-white rounded-xl border border-[var(--color-border)] shadow-sm min-w-0 overflow-hidden flex flex-col">
        <div class="p-4 border-b border-[var(--color-border)] flex flex-wrap justify-between items-center gap-3">
          <h3 class="text-sm font-medium text-[var(--color-fg-muted)]">Recent Transactions</h3>
          <div class="relative min-w-0 flex-1 sm:flex-initial sm:min-w-[160px]">
            <Search class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-[var(--color-fg-muted)] pointer-events-none" :stroke-width="1.5" />
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search..."
              class="w-full min-h-[44px] pl-9 pr-4 py-2 rounded-xl border border-[var(--color-border)] bg-white text-[var(--color-fg)] placeholder-[var(--color-fg-muted)] outline-none focus:ring-2 focus:ring-[var(--color-primary)]/30"
            />
          </div>
        </div>
        <div class="overflow-x-hidden flex-1 min-h-0">
          <div
            v-for="act in paginatedActivities"
            :key="act.id"
            class="flex items-center justify-between gap-2 px-4 py-3 min-h-[48px] border-b border-[var(--color-border)]/50 hover:bg-[var(--color-bg-light)] transition-colors"
          >
            <div class="flex items-center gap-3 min-w-0">
              <div class="w-9 h-9 rounded-full bg-[var(--color-bg-card)] border border-[var(--color-border)] flex items-center justify-center text-sm font-semibold text-[var(--color-fg-muted)] shrink-0">
                {{ (act.user || '?').charAt(0) }}
              </div>
              <div class="min-w-0">
                <p class="text-sm font-medium text-[var(--color-fg)] truncate">{{ act.message }}</p>
                <p class="text-xs text-[var(--color-fg-muted)] truncate">{{ act.user }}</p>
              </div>
            </div>
            <div class="flex items-center gap-2 shrink-0">
              <span :class="getStatusBadge(act.status)" class="px-2 py-1 rounded-lg text-xs font-semibold uppercase">
                {{ act.status }}
              </span>
              <span class="text-xs text-[var(--color-fg-muted)]">{{ formatDate(act.created_at) }}</span>
            </div>
          </div>
          <div v-if="paginatedActivities.length === 0" class="px-5 py-8 text-center text-[var(--color-fg-muted)] text-sm">
            No recent activity
          </div>
        </div>
        <div class="p-3 border-t border-[var(--color-border)] flex justify-center items-center gap-2 flex-wrap">
          <button
            @click="currentPage--"
            :disabled="currentPage === 1"
            class="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-xl border border-[var(--color-border)] bg-white hover:bg-[var(--color-bg-light)] disabled:opacity-40 transition-colors"
          >
            <ChevronLeft class="w-4 h-4 text-[var(--color-fg-muted)]" :stroke-width="1.5" />
          </button>
          <div class="flex gap-1">
            <button
              v-for="page in totalPages"
              :key="page"
              @click="currentPage = page"
              :class="currentPage === page ? 'bg-[var(--color-primary)] text-white border-[var(--color-primary)]' : 'bg-white text-[var(--color-fg-muted)] border-[var(--color-border)] hover:bg-[var(--color-bg-light)]'"
              class="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-xl text-sm font-semibold border transition-colors"
            >
              {{ page }}
            </button>
          </div>
          <button
            @click="currentPage++"
            :disabled="currentPage === totalPages"
            class="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-xl border border-[var(--color-border)] bg-white hover:bg-[var(--color-bg-light)] disabled:opacity-40 transition-colors"
          >
            <ChevronRight class="w-4 h-4 text-[var(--color-fg-muted)]" :stroke-width="1.5" />
          </button>
        </div>
      </div>
    </div>

    <div class="md:hidden h-20" aria-hidden="true"></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import {
  AlertTriangle,
  TrendingUp,
  Search,
  ChevronLeft,
  ChevronRight,
  Wrench,
  Package,
} from 'lucide-vue-next'
import api from '@/services/api'
import { useExchangeRateStore } from '@/stores/exchangeRate'
import BusinessInsightCard from '@/components/BusinessInsightCard.vue'
import StockPredictionCard from '@/components/StockPredictionCard.vue'

const router = useRouter()
const route = useRoute()
const exchangeRate = useExchangeRateStore()

const selectedTimeFilter = ref('Monthly')
const timeOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly']
const searchQuery = ref('')
const currentPage = ref(1)
const itemsPerPage = 8

const locations = ref([])
const activities = ref([])
const topCards = ref([
  { label: 'Total Sales', value: '0 Ks', path: null },
  { label: 'Active Services', value: '0', path: null },
  { label: 'Low Stock Items', value: '0 SKUs', path: '/reports/inventory' },
  { label: 'Revenue Growth', value: '0%', path: null },
])
const salesTrendData = ref([31, 40, 28, 51, 42, 109, 100])
const smartInsights = ref([])
const insightsLoading = ref(false)
const installationJobsCount = ref('—')
const todayPl = ref(null)

const totalRevenueDisplay = computed(() => {
  const raw = topCards.value[0]?.value ?? '0 Ks'
  return raw
})

const usdRateDisplay = computed(() => {
  const rate = exchangeRate.usdExchangeRate
  if (rate != null && Number(rate) > 0) return Math.round(Number(rate)).toLocaleString(undefined, { maximumFractionDigits: 0 })
  return '—'
})

const fetchSmartInsights = async () => {
  insightsLoading.value = true
  try {
    // api service က auto token injection လုပ်ပေးတယ်
    const res = await api.get('ai/insights/')
    smartInsights.value = res.data?.insights || []
  } catch {
    smartInsights.value = []
  } finally {
    insightsLoading.value = false
  }
}

const fetchAllData = async () => {
  const params = { period: selectedTimeFilter.value.toLowerCase() }
  const queryDate = route.query.date
  if (queryDate && /^\d{4}-\d{2}-\d{2}$/.test(queryDate)) params.date = queryDate
  try {
    // api service က auto token injection လုပ်ပေးတယ်
    const res = await api.get('dashboard/analytics/', { params })
    const data = res.data
    if (data.stats) {
      topCards.value[0].value = `${Math.round(Number(data.stats.total_revenue || 0)).toLocaleString(undefined, { maximumFractionDigits: 0 })} Ks`
      topCards.value[1].value = String(data.stats.active_services || 0)
      topCards.value[2].value = `${data.stats.low_stock_count || 0} SKUs`
      topCards.value[3].value = data.stats.revenue_growth || '0%'
      installationJobsCount.value = data.stats.installation_jobs_count != null ? String(data.stats.installation_jobs_count) : '—'
      todayPl.value = data.stats.today_pl || null
    } else {
      todayPl.value = null
    }
    activities.value = (data.recent_activities || []).map((act) => ({
      id: act.id,
      message: act.message,
      user: act.user__username || act.user || 'Unknown',
      status: act.status || 'Completed',
      created_at: act.created_at,
    }))
    locations.value = data.charts?.channel_performance || []
    if (data.charts?.sales_trend?.values) salesTrendData.value = data.charts.sales_trend.values
  } catch (err) {
    console.error('Fetch error:', err)
  }
}

const formatDate = (date) =>
  new Date(date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
const formatTodayCurrency = (val) => {
  if (val == null || val === '') return '—'
  const n = Number(val)
  if (Number.isNaN(n)) return String(val)
  return Math.round(Number(n) || 0).toLocaleString(undefined, { maximumFractionDigits: 0, minimumFractionDigits: 0 }) + ' Ks'
}
const getStatusBadge = (s) => {
  const st = (s || '').toLowerCase()
  if (st === 'completed' || st === 'success') return 'bg-emerald-50 text-emerald-700 border border-emerald-200'
  if (st === 'pending' || st === 'processing') return 'bg-amber-50 text-amber-700 border border-amber-200'
  return 'bg-rose-50 text-rose-700 border border-rose-200'
}

const filteredActivities = computed(() =>
  activities.value.filter((a) => a.message.toLowerCase().includes(searchQuery.value.toLowerCase())),
)
const totalPages = computed(() => Math.ceil(filteredActivities.value.length / itemsPerPage) || 1)
const paginatedActivities = computed(() =>
  filteredActivities.value.slice(
    (currentPage.value - 1) * itemsPerPage,
    currentPage.value * itemsPerPage,
  ),
)

onMounted(async () => {
  if (route.query.date) selectedTimeFilter.value = 'Daily'
  await exchangeRate.fetchExchangeRate()
  fetchAllData()
  fetchSmartInsights()
})
watch(
  () => route.query.date,
  () => {
    if (route.query.date) selectedTimeFilter.value = 'Daily'
    fetchAllData()
  },
)
</script>

<style scoped>
.dashboard {
  padding: 0;
}
</style>
