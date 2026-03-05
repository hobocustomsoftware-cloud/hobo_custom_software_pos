/**
 * လိုတာတွေစစ်ပြီး: Backend စတင် → Frontend စတင် → စောင့် → Marketing Screenshot (Playwright) ရိုက်မယ်
 * အရင် screenshot တွေမဖျက်ပစ်ဘဲ yp_posf/screenshots_for_marketing/ အတွင်းမှာ run_YYYY-MM-DD_HH-mm-ss/ ထပ်ထည့်သိမ်းမယ်
 * Run from repo root: node run_marketing_screenshots.mjs
 * Requires: Node, Python (Django), npm (Vite), Playwright
 */
import { spawn } from 'child_process'
import path from 'path'
import fs from 'fs'
import { fileURLToPath } from 'url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const ROOT = __dirname
const YP_POSF = path.join(ROOT, 'yp_posf')
const FRONTEND_URL = 'http://localhost:5173'
const BACKEND_URL = 'http://127.0.0.1:8000'
const WAIT_MS = 400
const MAX_ATTEMPTS = 75

function waitForUrl(url) {
  return new Promise((resolve, reject) => {
    let attempts = 0
    const tryFetch = () => {
      fetch(url, { method: 'GET', signal: AbortSignal.timeout(2000) })
        .then(() => resolve())
        .catch(() => {
          attempts++
          if (attempts >= MAX_ATTEMPTS) return reject(new Error(`${url} did not start in time`))
          setTimeout(tryFetch, WAIT_MS)
        })
    }
    tryFetch()
  })
}

async function main() {
  console.log('1) Starting Backend (Django on :8000)...')
  const backend = spawn('cmd', ['/c', 'run_backend_silent.bat'], {
    cwd: ROOT,
    shell: true,
    detached: true,
    stdio: 'ignore',
  })
  backend.unref()

  console.log('2) Waiting for Backend', BACKEND_URL, '...')
  await waitForUrl(BACKEND_URL).catch((e) => {
    console.warn('   Backend wait failed:', e.message)
  })
  console.log('   Backend OK.')

  console.log('3) Starting Frontend (Vite on :5173)...')
  const frontend = spawn('npx', ['vite'], {
    cwd: YP_POSF,
    shell: true,
    detached: true,
    stdio: 'ignore',
  })
  frontend.unref()

  console.log('4) Waiting for Frontend', FRONTEND_URL, '...')
  await waitForUrl(FRONTEND_URL)
  console.log('   Frontend OK.\n')

  console.log('5) Running Playwright marketing screenshots (login + 8 pages)...')
  const pw = spawn('npx', ['playwright', 'test', 'e2e/screenshots-for-marketing.spec.js', '--project=chromium'], {
    stdio: 'inherit',
    shell: true,
    cwd: YP_POSF,
    env: { ...process.env, PLAYWRIGHT_BASE_URL: FRONTEND_URL },
  })
  const exitCode = await new Promise((resolve) => pw.on('close', resolve))

  const outBase = path.join(YP_POSF, 'screenshots_for_marketing')
  if (fs.existsSync(outBase)) {
    const dirs = fs.readdirSync(outBase, { withFileTypes: true }).filter((d) => d.isDirectory() && d.name.startsWith('run_'))
    console.log('\nScreenshot runs in', outBase + ':', dirs.length, 'run(s). Latest:', dirs.map((d) => d.name).sort().pop() || '-')
  }

  process.exit(exitCode)
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
