<template>
  <div class="product-management-loyverse space-y-6 text-[var(--color-fg)]">
    <div v-if="!hideHeader" class="flex flex-wrap justify-between items-center gap-4">
      <h1 class="text-xl font-semibold text-[#1a1a1a]">Product Management</h1>
      <div class="flex items-center flex-wrap gap-2">
        <button @click="openScanModal" class="loyverse-btn-secondary px-4 py-2.5 flex items-center gap-2 rounded-xl text-sm font-medium">
          <ScanLine class="w-4 h-4" /> SCAN
        </button>
        <button @click="openAddModal" class="loyverse-btn-primary px-5 py-2.5 flex items-center gap-2 rounded-xl text-sm font-medium text-white">
          <Plus class="w-4 h-4" /> ADD PRODUCT
        </button>
      </div>
    </div>

    <FilterDataTable
      ref="tableRef"
      title="Products"
      :light="hideHeader"
      :columns="tableColumns"
      :data="products"
      :total-count="productsTotalCount"
      :loading="productsLoading"
      search-placeholder="Search or Scan Barcode..."
      :default-page-size="20"
      empty-message="ပစ္စည်း မရှိသေးပါ။"
      @fetch-data="fetchProducts"
    >
      <template #cell-name="{ row }">
        <span class="font-semibold text-[#1a1a1a]">{{ row.name }}</span>
      </template>
      <template #cell-sku="{ row }">
        <div class="flex flex-col items-start space-y-1">
          <BarcodeGenerator v-if="row.sku" :value="row.sku" class="opacity-80 hover:opacity-100 transition-all duration-300" />
          <span class="font-mono text-sm text-[var(--color-fg-muted)]">{{ row.sku || 'N/A' }}</span>
        </div>
      </template>
      <template #cell-category_name="{ value }">
        <span class="px-3 py-1.5 rounded-lg text-sm font-medium border border-[var(--color-border)] bg-[var(--color-bg-card)] text-[#1a1a1a]">
          {{ value || 'Uncategorized' }}
        </span>
      </template>
      <template #cell-retail_price="{ row }">
        <div class="font-semibold text-[#1a1a1a]">{{ Math.round(Number(row.retail_price) || 0).toLocaleString(undefined, { maximumFractionDigits: 0 }) }} MMK</div>
        <div class="text-sm text-[var(--color-fg-muted)]">Cost: {{ Math.round(Number(row.cost_price) || 0).toLocaleString(undefined, { maximumFractionDigits: 0 }) }}</div>
      </template>
      <template #cell-is_serial_tracked="{ value }">
        <div class="text-center">
          <CheckCircle2 v-if="value" class="w-5 h-5 text-emerald-600 mx-auto" />
          <XCircle v-else class="w-5 h-5 text-[var(--color-border)] mx-auto" />
        </div>
      </template>
      <template #actions="{ row }">
        <div class="flex items-center justify-end gap-2">
          <button @click="printBarcode(row)" class="text-emerald-600 font-medium text-sm hover:underline">PRINT</button>
          <button @click="cloneProduct(row)" class="text-amber-600 font-medium text-sm hover:underline">CLONE</button>
          <button @click="openEditModal(row)" class="text-[var(--loyverse-blue)] font-medium text-sm hover:underline">EDIT</button>
          <button @click="deleteProduct(row.id)" class="text-rose-600 font-medium text-sm hover:underline">DELETE</button>
        </div>
      </template>
    </FilterDataTable>

    <div v-if="showModal" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div
        class="absolute inset-0 bg-black/60 backdrop-blur-sm"
        @click="showModal = false"
      ></div>
      <div
        class="glass-card w-full max-w-2xl max-h-[90vh] flex flex-col p-6 sm:p-8 relative z-10"
      >
        <h3 class="text-xl font-semibold text-[#1a1a1a] mb-4 flex-shrink-0">
          {{ isEdit ? 'Update Product' : 'Add Product' }}
        </h3>

        <!-- Tabs -->
        <div class="flex gap-1 border-b border-[var(--surface-border)] mb-4 flex-shrink-0">
          <button
            type="button"
            class="px-4 py-2.5 text-sm font-medium rounded-t-lg transition-colors"
            :class="productModalTab === 'basic' ? 'bg-[var(--color-bg-light)] text-[var(--loyverse-blue)] border-b-2 border-[var(--loyverse-blue)]' : 'text-[var(--color-fg-muted)] hover:bg-white/5'"
            @click="productModalTab = 'basic'"
          >
            Basic
          </button>
          <button
            type="button"
            class="px-4 py-2.5 text-sm font-medium rounded-t-lg transition-colors"
            :class="productModalTab === 'units' ? 'bg-[var(--color-bg-light)] text-[var(--loyverse-blue)] border-b-2 border-[var(--loyverse-blue)]' : 'text-[var(--color-fg-muted)] hover:bg-white/5'"
            @click="productModalTab = 'units'"
          >
            Units
          </button>
          <button
            type="button"
            class="px-4 py-2.5 text-sm font-medium rounded-t-lg transition-colors"
            :class="productModalTab === 'specs' ? 'bg-[var(--color-bg-light)] text-[var(--loyverse-blue)] border-b-2 border-[var(--loyverse-blue)]' : 'text-[var(--color-fg-muted)] hover:bg-white/5'"
            @click="productModalTab = 'specs'"
          >
            Specs
          </button>
          <button
            type="button"
            class="px-4 py-2.5 text-sm font-medium rounded-t-lg transition-colors"
            :class="productModalTab === 'serial' ? 'bg-[var(--color-bg-light)] text-[var(--loyverse-blue)] border-b-2 border-[var(--loyverse-blue)]' : 'text-[var(--color-fg-muted)] hover:bg-white/5'"
            @click="productModalTab = 'serial'"
          >
            Serial
          </button>
        </div>

        <form @submit.prevent="saveProduct" class="flex flex-col min-h-0 flex-1 overflow-hidden">
          <div class="overflow-y-auto flex-1 min-h-0 space-y-4 pr-1">
            <!-- Tab: Basic -->
            <div v-show="productModalTab === 'basic'" class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="col-span-2">
                <label class="glass-label block mb-2">Product Name</label>
                <input v-model="form.name" type="text" required class="glass-input w-full px-4 py-3 rounded-xl" />
              </div>
              <div>
                <label class="glass-label block mb-2">SKU / Barcode</label>
                <input v-model="form.sku" type="text" placeholder="Leave blank to auto-generate" class="glass-input w-full px-4 py-3 rounded-xl" />
              </div>
              <div>
                <label class="glass-label block mb-2">Model Number</label>
                <input v-model="form.model_no" type="text" placeholder="e.g. INV-2000, BAT-100AH" class="glass-input w-full px-4 py-3 rounded-xl" />
              </div>
              <div>
                <label class="glass-label block mb-2">Category</label>
                <select v-model="form.category" class="glass-input w-full px-4 py-3 rounded-xl appearance-none">
                  <option :value="null">UNCATEGORIZED</option>
                  <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name.toUpperCase() }}</option>
                </select>
              </div>
              <div>
                <label class="glass-label block mb-2">Unit Type</label>
                <select v-model="form.unit_type" class="glass-input w-full px-4 py-3 rounded-xl appearance-none">
                  <option value="PCS">Pieces (PCS)</option>
                  <option value="CARD">Card (CARD)</option>
                  <option value="SET">Sets (SET)</option>
                  <option value="MTR">Meters (MTR)</option>
                  <option value="ROL">Rolls (ROL)</option>
                  <option value="KG">Kilograms (KG)</option>
                  <option value="BOX">Boxes (BOX)</option>
                  <option value="PKG">Packages (PKG)</option>
                  <option value="UNT">Units (UNT)</option>
                </select>
              </div>
              <div>
                <label class="glass-label block mb-2">Cost Price (MMK)</label>
                <input v-model.number="form.cost_price" type="number" min="0" step="1" required class="glass-input w-full px-4 py-3 rounded-xl" />
              </div>
              <div>
                <label class="glass-label block mb-2">Retail Price (MMK)</label>
                <input v-model.number="form.retail_price" type="number" min="0" step="1" required class="glass-input w-full px-4 py-3 rounded-xl" />
              </div>
            </div>

            <!-- Tab: Units -->
            <div v-show="productModalTab === 'units'" class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div v-if="units.length > 0" class="col-span-2 md:col-span-1">
                <label class="glass-label block mb-2">Base unit (ယူနစ်)</label>
                <select v-model="form.base_unit" class="glass-input w-full px-4 py-3 rounded-xl appearance-none">
                  <option :value="null">— Select —</option>
                  <option v-for="u in units" :key="u.id" :value="u.id">{{ u.name_my }} / {{ u.name_en }} ({{ u.code }})</option>
                </select>
              </div>
              <div v-if="units.length > 0" class="col-span-2 md:col-span-1">
                <label class="glass-label block mb-2">Purchase unit (optional)</label>
                <select v-model="form.purchase_unit" class="glass-input w-full px-4 py-3 rounded-xl appearance-none">
                  <option :value="null">— None —</option>
                  <option v-for="u in units" :key="'pu-' + u.id" :value="u.id">{{ u.name_my }} / {{ u.name_en }} ({{ u.code }})</option>
                </select>
              </div>
              <div v-if="form.purchase_unit && form.base_unit" class="col-span-2">
                <label class="glass-label block mb-2">1 Purchase unit = X Base units</label>
                <input v-model.number="form.purchase_unit_factor" type="number" min="1" step="1" class="glass-input w-full px-4 py-3 rounded-xl" placeholder="e.g. 10" />
              </div>
              <p v-if="units.length === 0" class="col-span-2 text-sm text-[var(--color-fg-muted)]">Complete Setup Wizard to get units for your business type.</p>
            </div>

            <!-- Tab: Specs -->
            <div v-show="productModalTab === 'specs'" class="glass-surface p-5 rounded-xl border border-[var(--surface-border)]">
              <div class="flex items-center justify-between mb-4">
                <label class="glass-label text-lg font-bold">Specifications</label>
                <button type="button" @click="addSpecification" class="btn-secondary px-4 py-2 flex items-center gap-2 interactive">
                  <Plus class="w-4 h-4" /> Add Row
                </button>
              </div>
              <div class="space-y-3">
                <div v-for="(spec, index) in form.specifications" :key="index" class="flex gap-3 items-center">
                  <input v-model="spec.label" type="text" placeholder="Label (e.g., Voltage)" class="glass-input flex-1 px-4 py-2 rounded-xl" />
                  <input v-model="spec.value" type="text" placeholder="Value (e.g., 220V)" class="glass-input flex-1 px-4 py-2 rounded-xl" />
                  <button type="button" @click="removeSpecification(index)" class="text-red-300 hover:text-red-200 px-3 py-2 interactive">Remove</button>
                </div>
                <p v-if="form.specifications.length === 0" class="text-white/40 text-sm italic">Click "Add Row" to add technical specs.</p>
              </div>
            </div>

            <!-- Tab: Serial -->
            <div v-show="productModalTab === 'serial'" class="glass-surface p-5 rounded-xl border border-[var(--surface-border)] space-y-4">
              <div class="flex items-center gap-4">
                <input v-model="form.is_serial_tracked" type="checkbox" id="serial" class="w-5 h-5 rounded-lg accent-[#aa0000]" />
                <label for="serial" class="glass-label cursor-pointer">Enable serial number tracking</label>
              </div>
              <div class="flex items-center gap-4">
                <input v-model="form.serial_number_required" type="checkbox" id="serial_required" class="w-5 h-5 rounded-lg accent-[#aa0000]" />
                <label for="serial_required" class="glass-label cursor-pointer">Serial required (e.g. Inverter/Battery)</label>
              </div>
            </div>
          </div>

          <div class="flex gap-4 pt-4 mt-4 border-t border-[var(--surface-border)] flex-shrink-0">
            <button type="button" @click="showModal = false" class="flex-1 loyverse-btn-secondary py-3 rounded-xl">Cancel</button>
            <button type="submit" :disabled="submitting" class="flex-1 loyverse-btn-primary py-3 rounded-xl text-white disabled:opacity-50 disabled:cursor-not-allowed">
              {{ submitting ? 'Processing...' : 'Save Product' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <BarcodeScanner
      :show="showScanner"
      @scan="onScanResult"
      @close="showScanner = false"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { CheckCircle2, XCircle, ScanLine, Plus } from 'lucide-vue-next'

defineProps({
  /** When true, hide page title and action buttons (for use inside Item List tabs) */
  hideHeader: { type: Boolean, default: false },
})
import JsBarcode from 'jsbarcode'
import BarcodeGenerator from '../../components/BarcodeGenerator.vue'
import BarcodeScanner from '../../components/BarcodeScanner.vue'
import FilterDataTable from '@/components/FilterDataTable.vue'
import { useToast } from '@/composables/useToast'
import { useShopSettingsStore } from '@/stores/shopSettings'
import api from '@/services/api'

const toast = useToast()

const showScanner = ref(false)
const categories = ref([])
const units = ref([])
const scannerBuffer = ref('')
const showModal = ref(false)
const productModalTab = ref('basic')
const submitting = ref(false)
const isEdit = ref(false)
const currentId = ref(null)

const form = ref({
  name: '',
  category: null,
  sku: '',
  model_no: '',
  retail_price: 0,
  cost_price: 0,
  unit_type: 'PCS',
  base_unit: null,
  purchase_unit: null,
  purchase_unit_factor: 1,
  is_serial_tracked: false,
  serial_number_required: false,
  specifications: [],
})

const tableRef = ref(null)
const products = ref([])
const productsTotalCount = ref(0)
const productsLoading = ref(false)
const tableColumns = [
  { key: 'name', label: 'Product Info', sortable: true },
  { key: 'sku', label: 'SKU / Barcode', sortable: true },
  { key: 'model_no', label: 'Model No.', sortable: true },
  { key: 'category_name', label: 'Category', sortable: true },
  { key: 'retail_price', label: 'Price (Retail/Cost)', sortable: true },
  { key: 'is_serial_tracked', label: 'Serial Track', sortable: false },
]

async function fetchUnits() {
  try {
    const shopStore = useShopSettingsStore()
    const params = {}
    if (shopStore.filter_units_by_business_category && shopStore.business_category) params.business_category = shopStore.business_category
    const res = await api.get('units/', { params })
    units.value = Array.isArray(res.data) ? res.data : (res.data?.results ?? [])
  } catch {
    units.value = []
  }
}

async function fetchProducts({ search, page, pageSize, ordering }) {
  productsLoading.value = true
  const params = { page, page_size: pageSize }
  if (search) params.search = search
  if (ordering) params.ordering = ordering
  try {
    const res = await api.get('products-admin/', { params })
    const data = res.data
    products.value = Array.isArray(data) ? data : (data?.results ?? [])
    productsTotalCount.value = data?.count ?? products.value.length
  } catch (err) {
    products.value = []
    productsTotalCount.value = 0
    toast.error(err.response?.data?.detail || 'Could not load products')
  } finally {
    productsLoading.value = false
  }
}

const handleGlobalKeyDown = (event) => {
  if (event.key === 'Enter') {
    if (scannerBuffer.value.length > 2) {
      tableRef.value?.setSearchAndFetch(scannerBuffer.value)
      scannerBuffer.value = ''
    }
  } else if (event.key.length === 1) {
    scannerBuffer.value += event.key
    setTimeout(() => { scannerBuffer.value = '' }, 1000)
  }
}

async function fetchCategories() {
  try {
    const cRes = await api.get('categories/')
    categories.value = cRes.data.results ?? cRes.data ?? []
  } catch (err) {
    console.error('Categories fetch error:', err)
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleGlobalKeyDown)
  fetchCategories()
  fetchUnits()
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleGlobalKeyDown)
})

// ၄။ CRUD Logic
const openScanModal = () => {
  showScanner.value = true
}

const onScanResult = async (code) => {
  showScanner.value = false
  const q = (code || '').trim()
  if (!q) return
  try {
    const res = await api.get('products/search/', { params: { q } })
    if (res.data?.found && res.data?.product) {
      openEditModal(res.data.product)
      toast.success('Product loaded from scan')
    } else {
      form.value = {
        name: '',
        category: null,
        sku: q,
        model_no: '',
        retail_price: 0,
        cost_price: 0,
        unit_type: 'PCS',
        base_unit: null,
        purchase_unit: null,
        purchase_unit_factor: 1,
        is_serial_tracked: false,
        serial_number_required: false,
        specifications: [],
      }
      isEdit.value = false
      currentId.value = null
      showModal.value = true
      toast.info('No match — add as new product or edit SKU')
    }
  } catch (err) {
    toast.error(err.response?.data?.error || 'Lookup failed')
    form.value = { ...form.value, sku: q }
    isEdit.value = false
    currentId.value = null
    showModal.value = true
  }
}

const addSpecification = () => {
  form.value.specifications.push({ label: '', value: '', order: form.value.specifications.length })
}

const removeSpecification = (index) => {
  form.value.specifications.splice(index, 1)
}

const openAddModal = () => {
  isEdit.value = false
  form.value = {
    name: '',
    category: null,
    sku: '',
    model_no: '',
    retail_price: 0,
    cost_price: 0,
    unit_type: 'PCS',
    base_unit: null,
    purchase_unit: null,
    purchase_unit_factor: 1,
    is_serial_tracked: false,
    serial_number_required: false,
    specifications: [],
  }
  showModal.value = true
}

const openEditModal = async (p) => {
  isEdit.value = true
  currentId.value = p.id
  
  // Load specifications: handle array or object from API
  let specs = []
  const rawSpecs = p.specifications
  if (Array.isArray(rawSpecs) && rawSpecs.length > 0) {
    specs = rawSpecs.map(s => ({ label: s?.label ?? '', value: s?.value ?? '', order: s?.order ?? 0 }))
  } else if (p.id) {
    try {
      const res = await api.get('product-specifications/', { params: { product_id: p.id } })
      const raw = res.data
      const list = Array.isArray(raw) ? raw : (raw?.results ?? [])
      specs = (list || []).map(s => ({ label: s?.label ?? '', value: s?.value ?? '', order: s?.order ?? 0 }))
    } catch (err) {
      console.warn('Failed to load specifications:', err)
      toast.error(err.response?.data?.detail || 'Could not load product specifications')
    }
  }
  
  form.value = {
    ...p,
    specifications: specs,
    unit_type: p.unit_type || 'PCS',
    base_unit: p.base_unit ?? null,
    purchase_unit: p.purchase_unit ?? null,
    purchase_unit_factor: p.purchase_unit_factor != null ? Number(p.purchase_unit_factor) : 1,
  }
  showModal.value = true
}

const cloneProduct = async (p) => {
  if (!confirm(`Clone "${p.name}"? This will create a copy with all specifications.`)) return
  try {
    const res = await api.post(`products-admin/${p.id}/clone/`)
    alert('Product cloned successfully!')
    tableRef.value?.emitFetch()
    // Open the cloned product for editing
    if (res.data.product) {
      openEditModal(res.data.product)
    }
  } catch (err) {
    alert('Failed to clone product')
    console.error(err)
  }
}

const saveProduct = async () => {
  submitting.value = true
  try {
    // Prepare product data (exclude specifications for now)
    const productData = { ...form.value }
    const specs = productData.specifications || []
    delete productData.specifications

    // Save product first
    let productId
    if (isEdit.value) {
      const res = await api.patch(`products-admin/${currentId.value}/`, productData)
      productId = currentId.value
    } else {
      const res = await api.post('products-admin/', productData)
      productId = res.data.id
    }

    // Save specifications
    if (productId && specs.length > 0) {
      // Delete existing specs if editing
      if (isEdit.value) {
        try {
          const existingSpecs = await api.get('product-specifications/', { params: { product_id: productId } })
          for (const spec of existingSpecs.data) {
            await api.delete(`product-specifications/${spec.id}/`)
          }
        } catch (err) {
          console.warn('Failed to delete old specs:', err)
        }
      }

      // Create new specs
      for (const spec of specs) {
        if (spec.label && spec.value) {
          await api.post('product-specifications/', {
            product: productId,
            label: spec.label.trim(),
            value: spec.value.trim(),
            order: spec.order || 0,
          })
        }
      }
    }

    showModal.value = false
    tableRef.value?.emitFetch()
  } catch (err) {
    alert('Failed to save product: ' + (err.response?.data?.detail || err.message))
    console.error(err)
  } finally {
    submitting.value = false
  }
}

const deleteProduct = async (id) => {
  if (!confirm('Are you sure you want to delete this product?')) return
  try {
    // api service က auto token injection လုပ်ပေးတယ်
    await api.delete(`products-admin/${id}/`)
    tableRef.value?.emitFetch()
  } catch (err) {
    alert('Delete failed')
  }
}

const printBarcode = (p) => {
  // ယာယီ Window တစ်ခုဖွင့်ပြီး Print ထုတ်မယ့် Layout ချခြင်း
  const printWindow = window.open('', '_blank')

  // Barcode အတွက် SVG element တစ်ခုကို ယာယီဖန်တီးပါ
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg')

  JsBarcode(svg, p.sku, {
    format: 'CODE128',
    width: 2,
    height: 60,
    displayValue: true,
    fontSize: 18,
    text: `${p.name} (${p.sku})`, // ပစ္စည်းအမည်ပါ တစ်ခါတည်းပြရန်
  })

  printWindow.document.write(`
    <html>
      <head>
        <title>Print Barcode - ${p.sku}</title>
        <style>
          body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
          .label-container { text-align: center; border: 1px solid #eee; padding: 20px; }
        </style>
      </head>
      <body>
        <div class="label-container">
          <h2>WELDING SHOP</h2>
          ${svg.outerHTML}
          <p>Price: ${Math.round(Number(p.retail_price) || 0).toLocaleString(undefined, { maximumFractionDigits: 0 })} MMK</p>
        </div>
        <script>
          window.onload = () => { window.print(); window.close(); };
        <\/script>
      </body>
    </html>
  `)
  printWindow.document.close()
}

defineExpose({
  openAddModal,
  openEditModal,
  openScanModal,
})
</script>
