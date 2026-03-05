/**
 * UI language: 'en' | 'mm'
 * Persisted in localStorage so localhost and localhost:8000/app stay consistent.
 */
import { defineStore } from 'pinia'

const STORAGE_KEY = 'hobopos_locale'

export const useLocaleStore = defineStore('locale', {
  state: () => ({
    lang: (typeof localStorage !== 'undefined' && localStorage.getItem(STORAGE_KEY)) || 'mm',
  }),

  getters: {
    isEn: (state) => state.lang === 'en',
    isMm: (state) => state.lang === 'mm',
  },

  actions: {
    setLang(lang) {
      this.lang = lang === 'en' ? 'en' : 'mm'
      try {
        localStorage.setItem(STORAGE_KEY, this.lang)
      } catch (_) {}
    },
    toggle() {
      this.setLang(this.lang === 'en' ? 'mm' : 'en')
    },
  },
})

/** Auth page labels: EN / MM */
export const authLabels = {
  en: {
    signIn: 'Sign in',
    signInSub: 'Use your phone number or email to sign in',
    emailOrPhone: 'Phone Number or Email',
    password: 'Password',
    createAccount: 'Create account',
    createAccountSub: 'Enter phone number (primary) or email',
    phoneRequired: 'Phone Number',
    emailOptional: 'Email (optional)',
    shopName: 'Shop Name',
    confirmPassword: 'Confirm Password',
    createAccountBtn: 'Create account',
    alreadyHave: 'Already have an account?',
    signInLink: 'Sign in',
    forgotPassword: 'Forgot password?',
    signingIn: 'Signing in...',
    creating: 'Creating account...',
    setupWizard: 'Setup Wizard',
    completeSetup: 'Complete setup & go to Dashboard',
    businessType: 'Business Type',
    currency: 'Currency',
  },
  mm: {
    signIn: 'ဝင်ရောက်ရန်',
    signInSub: 'ဖုန်းနံပါတ် သို့မဟုတ် အီးမေးလ်ဖြင့် ဝင်ရောက်ပါ',
    emailOrPhone: 'ဖုန်းနံပါတ် သို့မဟုတ် အီးမေးလ်',
    password: 'စကားဝှက်',
    createAccount: 'အကောင့်ဖွင့်ရန်',
    createAccountSub: 'ဖုန်းနံပါတ် (အဓိက) သို့မဟုတ် အီးမေးလ်ထည့်ပါ',
    phoneRequired: 'ဖုန်းနံပါတ်',
    emailOptional: 'အီးမေးလ် (ရွေးချယ်မှု)',
    shopName: 'ဆိုင်အမည်',
    confirmPassword: 'စကားဝှက်အတည်ပြုရန်',
    createAccountBtn: 'အကောင့်ဖွင့်မည်',
    alreadyHave: 'အကောင့်ရှိပြီးသား ဖြစ်ပါသလား?',
    signInLink: 'ဝင်ရောက်ရန်',
    forgotPassword: 'စကားဝှက်မေ့သွားပါသလား?',
    signingIn: 'ဝင်နေပါတယ်...',
    creating: 'အကောင့်ဖွင့်နေပါတယ်...',
    setupWizard: 'ပထမဆုံးချိန်ညှိချက်',
    completeSetup: 'ပြီးပါပြီ ဒက်ရှ်ဘုတ်သို့သွားမည်',
    businessType: 'လုပ်ငန်းအမျိုးအစား',
    currency: 'ငွေကြေးအမျိုးအစား',
  },
}
