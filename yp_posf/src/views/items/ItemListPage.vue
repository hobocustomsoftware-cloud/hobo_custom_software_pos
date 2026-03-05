<template>
  <PageLayoutLoyverse
    title="Items"
    :card="false"
    main-bg="#f4f4f4"
  >
    <template #actions>
      <router-link
        v-if="activeTab === 'items'"
        to="/products/import"
        class="loyverse-btn-secondary px-4 py-2 rounded-xl text-sm font-medium flex items-center gap-2"
      >
        <Upload class="w-4 h-4" /> IMPORT
      </router-link>
      <button
        type="button"
        class="loyverse-btn-secondary px-4 py-2 rounded-xl text-sm font-medium flex items-center gap-2"
        @click="handleExport"
      >
        <Download class="w-4 h-4" /> EXPORT
      </button>
      <button
        v-if="activeTab === 'items'"
        type="button"
        class="loyverse-btn-secondary px-4 py-2 rounded-xl text-sm font-medium flex items-center gap-2"
        @click="productRef?.openPrintLabelsModal?.()"
      >
        <Printer class="w-4 h-4" /> PRINT LABELS
      </button>
      <button
        v-if="activeTab === 'items'"
        type="button"
        class="loyverse-btn-primary px-5 py-2.5 rounded-xl text-sm font-medium text-white flex items-center gap-2"
        @click="productRef?.openAddModal?.()"
      >
        <Plus class="w-4 h-4" /> ADD ITEM
      </button>
      <button
        v-if="activeTab === 'categories'"
        type="button"
        class="loyverse-btn-primary px-5 py-2.5 rounded-xl text-sm font-medium text-white flex items-center gap-2"
        @click="categoryRef?.openAddModal?.()"
      >
        <Plus class="w-4 h-4" /> ADD CATEGORY
      </button>
    </template>

    <!-- Loyverse-style Tabs: Items | Categories | Modifiers -->
    <div class="bg-white rounded-t-xl border border-b-0 border-[var(--color-border)] px-4 pt-2">
      <div class="flex gap-0 border-b border-[var(--color-border)] -mb-px">
        <button
          type="button"
          class="loyverse-tab px-4 py-3 text-sm font-medium"
          :class="{ 'loyverse-tab-active': activeTab === 'items' }"
          @click="activeTab = 'items'"
        >
          Items
        </button>
        <button
          type="button"
          class="loyverse-tab px-4 py-3 text-sm font-medium"
          :class="{ 'loyverse-tab-active': activeTab === 'categories' }"
          @click="activeTab = 'categories'"
        >
          Categories
        </button>
        <button
          type="button"
          class="loyverse-tab px-4 py-3 text-sm font-medium"
          :class="{ 'loyverse-tab-active': activeTab === 'modifiers' }"
          @click="activeTab = 'modifiers'"
        >
          Modifiers
        </button>
      </div>
    </div>

    <!-- Tab content in white card -->
    <div class="bg-white rounded-b-xl border border-t-0 border-[var(--color-border)] shadow-sm min-h-[400px] p-4 md:p-6">
      <div v-show="activeTab === 'items'" class="text-[#1a1a1a]">
        <ProductManagement ref="productRef" hide-header />
      </div>
      <div v-show="activeTab === 'categories'" class="text-[#1a1a1a]">
        <CategoryManagement ref="categoryRef" hide-header />
      </div>
      <div v-show="activeTab === 'modifiers'">
        <ItemsModifiers />
      </div>
    </div>
  </PageLayoutLoyverse>
</template>

<script setup>
import { ref } from 'vue'
import { Plus, Download, Upload, Printer } from 'lucide-vue-next'
import PageLayoutLoyverse from '@/components/PageLayoutLoyverse.vue'
import ProductManagement from '@/views/inventory/ProductManagement.vue'
import CategoryManagement from '@/views/inventory/CategoryManagement.vue'
import ItemsModifiers from '@/views/items/ItemsModifiers.vue'

const activeTab = ref('items')
const productRef = ref(null)
const categoryRef = ref(null)

function handleExport() {
  // TODO: wire to export API or CSV
  console.log('Export items')
}
</script>

<style scoped>
.loyverse-tab {
  color: var(--color-fg-muted);
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  transition: color 0.15s, border-color 0.15s;
}
.loyverse-tab:hover {
  color: var(--loyverse-blue);
}
.loyverse-tab-active {
  color: var(--loyverse-blue);
  border-bottom-color: var(--loyverse-blue);
}
</style>
