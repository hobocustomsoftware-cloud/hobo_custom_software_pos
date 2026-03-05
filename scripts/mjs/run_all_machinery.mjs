/**
 * တစ်ခါတည်း: Backend စတင် → Frontend စတင် → စောင့် → Machinery Screenshot ပြေး → ပြီး
 * Run from repo root: node run_all_machinery.mjs
 * Requires: Node, Python (Django/uvicorn), npm (Vite), Playwright
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
  console.log('1) Starting Backend (Django/Uvicorn on :8000)...')
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

  console.log('5) Running Machinery Shop simulation (7 days, screenshots)...')
  const sim = spawn('node', ['simulate_machinery_shop.js'], {
    stdio: 'inherit',
    shell: true,
    cwd: YP_POSF,
    env: { ...process.env, BASE_URL: FRONTEND_URL },
  })
  const exitCode = await new Promise((resolve) => sim.on('close', resolve))

  const outDir = path.join(YP_POSF, 'simulations', 'machinery_shop')
  if (fs.existsSync(outDir)) {
    const files = fs.readdirSync(outDir).filter((f) => f.endsWith('.png')).sort()
    console.log('\nScreenshots saved:', files.length, 'files in', outDir)
  }

  process.exit(exitCode)
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
