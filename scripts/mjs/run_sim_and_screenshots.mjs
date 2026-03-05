/**
 * တစ်လ simulation ပြီး → Backend → Frontend စောင့် → screenshot_story.py → build_slideshow.py
 * Run from repo root: node run_sim_and_screenshots.mjs
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
const WAIT_MS = 500
const MAX_ATTEMPTS = 120

function waitForUrl(url) {
  return new Promise((resolve, reject) => {
    let attempts = 0
    const tryFetch = () => {
      fetch(url, { method: 'GET', signal: AbortSignal.timeout(3000) })
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
  console.log('1) Starting Backend (Django :8000)...')
  const backend = spawn('cmd', ['/c', 'run_backend_silent.bat'], {
    cwd: ROOT,
    shell: true,
    detached: true,
    stdio: 'ignore',
  })
  backend.unref()

  console.log('2) Waiting for Backend...')
  await waitForUrl(BACKEND_URL).catch((e) => {
    console.warn('   Backend wait failed:', e.message)
  })
  console.log('   Backend OK.')

  console.log('3) Starting Frontend (Vite :5173)...')
  const frontend = spawn('npx', ['vite'], {
    cwd: YP_POSF,
    shell: true,
    detached: true,
    stdio: 'ignore',
  })
  frontend.unref()

  console.log('4) Waiting for Frontend...')
  await waitForUrl(FRONTEND_URL)
  console.log('   Frontend OK.\n')

  console.log('5) Running screenshot_story.py...')
  const py = spawn('python', ['screenshot_story.py'], {
    cwd: ROOT,
    shell: true,
    stdio: 'inherit',
    env: { ...process.env, FRONTEND_URL },
  })
  let exitCode = await new Promise((resolve) => py.on('close', resolve))

  if (exitCode !== 0) {
    console.error('\nScreenshot script exited with code', exitCode)
    process.exit(exitCode)
  }

  console.log('\n6) Building slideshow...')
  const slide = spawn('python', ['build_slideshow.py'], {
    cwd: ROOT,
    shell: true,
    stdio: 'inherit',
  })
  exitCode = await new Promise((resolve) => slide.on('close', resolve))

  if (fs.existsSync(path.join(ROOT, 'screenshots'))) {
    const count = fs.readdirSync(path.join(ROOT, 'screenshots'), { recursive: true }).filter((f) => f.endsWith('.png')).length
    console.log('\nScreenshots saved in screenshots/ (', count, 'images )')
  }
  process.exit(exitCode)
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
