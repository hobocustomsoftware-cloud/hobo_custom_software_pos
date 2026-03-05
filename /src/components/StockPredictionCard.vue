<template>
  <div class="glass-card p-5 rounded-2xl border border-[var(--surface-border)] glow-effect">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-bold text-white flex items-center gap-2">
        <span class="text-2xl">🔮</span>
        <span>Stock Predictions</span>
      </h3>
      <button
        @click="refresh"
        :disabled="loading"
        class="text-white/60 hover:text-white transition-colors disabled:opacity-50"
      >
        {{ loading ? '⏳' : '🔄' }}
      </button>
    </div>

    <div v-if="loading" class="text-center py-8 text-white/60">
      Analyzing stock movements...
    </div>

    <div v-else-if="paginatedPredictions.length > 0" class="space-y-3">
      <div
        v-for="(pred, idx) in paginatedPredictions"
        :key="idx"
        class="glass-surface p-4 rounded-xl border border-[var(--surface-border)]"
        :class="{
          'border-red-500/50': pred.status === 'out_of_stock',
          'border-amber-500/50': pred.status === 'low_stock',
        }"
      >
        <div class="flex items-start justify-between">
          <div class="flex-1">
            <h4 class="font-bold text-white mb-1">{{ pred.product_name }}</h4>
            <div class="flex items-center gap-2 mb-2">
              <span
                class="px-2 py-1 rounded text-xs font-bold"
                :class="{
                  'bg-red-500/20 text-red-300': pred.status === 'out_of_stock',
                  'bg-amber-500/20 text-amber-300': pred.status === 'low_stock',
                  'bg-green-500/20 text-green-300': pred.status === 'normal',
                }"
              >
                {{ pred.status === 'out_of_stock' ? 'Out of Stock' : pred.status === 'low_stock' ? 'Low Stock' : 'Normal' }}
              </span>
              <span class="text-xs text-white/60">Confidence: {{ pred.confidence }}</span>
            </div>
            <div class="space-y-1 text-sm">
              <div class="flex justify-between">
                <span class="text-white/80">Current Stock:</span>
                <span class="font-bold text-white">{{ pred.current_stock }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-white/80">Daily Avg Consumption:</span>
                <span class="font-bold text-white">{{ pred.daily_avg_consumption }}</span>
              </div>
              <div v-if="pred.predicted_out_of_stock_date" class="flex justify-between">
                <span class="text-white/80">Predicted Out of Stock:</span>
                <span
                  class="font-bold"
                  :class="pred.days_until_out_of_stock <= 7 ? 'text-red-400' : 'text-white'"
                >
                  {{ pred.predicted_out_of_stock_date }}
                  <span class="text-xs ml-1">({{ pred.days_until_out_of_stock }} days)</span>
                </span>
              </div>
              <div v-else class="flex justify-between">
                <span class="text-white/80">Status:</span>
                <span class="font-bold text-red-400">Already Out of Stock</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="text-center py-8 text-white/60">
      No predictions available. Need more movement data.
    </div>

    <!-- Paginator: limited items per page -->
    <div v-if="predictions.length > pageSize" class="mt-4 flex items-center justify-between border-t border-white/10 pt-3">
      <span class="text-xs text-white/50">
        {{ (currentPage - 1) * pageSize + 1 }}-{{ Math.min(currentPage * pageSize, predictions.length) }} of {{ predictions.length }}
      </span>
      <div class="flex gap-2">
        <button
          :disabled="currentPage <= 1"
          @click="currentPage--"
          class="px-3 py-1 rounded-lg bg-white/10 text-white/80 hover:bg-white/20 disabled:opacity-40 text-sm font-bold"
        >
          Prev
        </button>
        <button
          :disabled="currentPage >= totalPages"
          @click="currentPage++"
          class="px-3 py-1 rounded-lg bg-white/10 text-white/80 hover:bg-white/20 disabled:opacity-40 text-sm font-bold"
        >
          Next
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '@/services/api'

const PAGE_SIZE = 10
const predictions = ref([])
const loading = ref(false)
const currentPage = ref(1)

const totalPages = computed(() => Math.max(1, Math.ceil(predictions.value.length / PAGE_SIZE)))
const paginatedPredictions = computed(() => {
  const start = (currentPage.value - 1) * PAGE_SIZE
  return predictions.value.slice(start, start + PAGE_SIZE)
})
const pageSize = PAGE_SIZE

const fetchPredictions = async () => {
  loading.value = true
  try {
    const res = await api.get('ai/stock-prediction/', { params: { limit: 50, offset: 0 } })
    predictions.value = res.data.predictions || []
    currentPage.value = 1
  } catch (err) {
    console.error('Failed to fetch stock predictions:', err)
    predictions.value = []
  } finally {
    loading.value = false
  }
}

const refresh = () => {
  fetchPredictions()
}

onMounted(() => {
  fetchPredictions()
})
</script>

<style scoped>
.glow-effect {
  box-shadow: 0 0 20px rgba(170, 0, 0, 0.1);
}
</style>
