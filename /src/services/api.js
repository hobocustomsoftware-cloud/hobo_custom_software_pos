import axios from 'axios'
import { API_URL } from '@/config'
import router, { getLoginPath, getAppPath } from '@/router'
import { useAuthStore } from '@/stores/auth'
import { useToast } from '@/composables/useToast'

const api = axios.create({
  baseURL: API_URL,
})

// Request တိုင်းမှာ Token ပါသွားအောင် လုပ်ခြင်း
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('access_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 403 license_expired → License Activation; trial_expired → Trial Expired page with contact
// 401 → logout and login; 500/503 → toast so UI does not stay blank
api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 403 && err.response?.data?.error === 'license_expired') {
      router.push(getAppPath('/license-activate'))
      return Promise.reject(err)
    }
    if (err.response?.status === 403 && err.response?.data?.error === 'trial_expired') {
      const contact = err.response?.data?.contact || ''
      router.push({ path: getAppPath('/trial-expired'), query: contact ? { contact: encodeURIComponent(contact) } : {} })
      return Promise.reject(err)
    }
    if (err.response?.status === 401) {
      const isLoginRequest = err.config?.url?.includes('auth/login')
      useAuthStore().logout()
      // Don't redirect if 401 came from login attempt (show error on login page)
      if (!isLoginRequest && router.currentRoute?.value?.meta?.public !== true) {
        router.push(getLoginPath())
      }
    }
    // 500, 503: show toast so user sees feedback instead of blank/failed state
    const status = err.response?.status
    if (status === 500 || status === 503) {
      const toast = useToast()
      const msg = status === 503
        ? 'ဆာဗာ ယာယီမရပါ။ ခဏကြာပြီး ထပ်ကြိုးစားပါ။'
        : 'ဆာဗာအမှား ဖြစ်ပါသည်။ ထပ်ကြိုးစားပါ။'
      toast.error(msg)
    }
    return Promise.reject(err)
  }
)

export default api
