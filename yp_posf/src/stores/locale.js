import { defineStore } from 'pinia'

const STORAGE_KEY = 'app_locale'

/** Auth page labels (Login, Register, Forgot password) – EN / MY */
export const authLabels = {
  en: {
    signIn: 'Sign in',
    signInSub: 'Enter your phone or email and password.',
    emailOrPhone: 'Phone or Email',
    forgotPassword: 'Forgot password?',
    signingIn: 'Signing in...',
    signInLink: 'Already have an account? Sign in',
    createAccount: 'Create account',
    registerTitle: 'Create account',
    registerSub: 'Register with your phone or email.',
  },
  mm: {
    signIn: 'အကောင့်ဝင်မည်',
    signInSub: 'ဖုန်းနံပါတ် သို့မဟုတ် အီးမေးလ်နဲ့ စကားဝှက် ထည့်ပါ။',
    emailOrPhone: 'ဖုန်းနံပါတ် သို့မဟုတ် အီးမေးလ်',
    forgotPassword: 'စကားဝှက် မေ့နေပါသလား?',
    signingIn: 'ဝင်နေပါသည်...',
    signInLink: 'အကောင့်ရှိပြီးသား ဆိုရင် ဝင်မည်',
    createAccount: 'အကောင့်ဖွင့်မည်',
    registerTitle: 'အကောင့်ဖွင့်ရန်',
    registerSub: 'ဖုန်းနံပါတ် သို့မဟုတ် အီးမေးလ်ဖြင့် စာရင်းသွင်းပါ။',
  },
}

export const useLocaleStore = defineStore('locale', {
  state: () => ({
    locale: (() => {
      try {
        const v = localStorage.getItem(STORAGE_KEY) || 'mm'
        return v === 'my' ? 'mm' : v
      } catch {
        return 'mm'
      }
    })(),
  }),

  getters: {
    lang: (state) => state.locale,
    isEn: (state) => state.locale === 'en',
    isMm: (state) => state.locale === 'mm',
    isMy: (state) => state.locale === 'mm',
  },

  actions: {
    setLang(val) {
      if (val === 'en' || val === 'mm') {
        this.locale = val
        try {
          localStorage.setItem(STORAGE_KEY, val)
        } catch (_) {}
      }
    },
    setLocale(val) {
      this.setLang(val === 'my' ? 'mm' : val)
    },
  },
})
