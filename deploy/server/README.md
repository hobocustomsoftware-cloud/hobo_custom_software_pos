# HoBo POS - Server Deployment (Production)

Docker ဖြင့် Server ပေါ်တင် လုပ်ဆောင်ခြင်း။ SRE + Security ပါဝင်ပြီး။

## Prerequisites

- Docker & Docker Compose
- .env file (from .env.example)

## Quick Start

```bash
# Project root မှာ
docker-compose -f deploy/server/docker-compose.yml up -d --build
```

## SRE (Health Checks)

| Endpoint | Purpose |
|----------|---------|
| `GET /health/` | Liveness - app လည်ပတ်နေပါသလား |
| `GET /health/ready/` | Readiness - DB ချိတ်ဆက်ပြီးပါပြီလား |

Docker healthcheck: backend container က 30s ကြာတိုင်း `/health/` စစ်ဆေးသည်။

## Security

- **Rate limiting:** License activate 10/min, Remote license 30/min, Auth 20/min
- **Headers:** XSS filter, Content-Type nosniff, HSTS (production)
- **Cookies:** Secure, HttpOnly (DEBUG=False)

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| DJANGO_SECRET_KEY | Django secret | (required) |
| DJANGO_DEBUG | Debug mode | False |
| POSTGRES_PASSWORD | DB password | (required) |
| POSTGRES_DB | Database name | hobo_pos |
| POSTGRES_USER | DB user | hobo |
| VITE_API_URL | Frontend API base | /api |
| DJANGO_ALLOWED_HOSTS | Comma-separated hosts | localhost,127.0.0.1 |
| OPENAI_API_KEY | AI (suggest/ask/insights) ပြည့်အလုပ်လုပ်ချင် | (optional) |
| AI_API_URL | OpenAI-compatible endpoint (Ollama/Gemini URL လည်းရတယ်) | (optional) |
| AI_MODEL | Model name | (optional) |

## Ports

- 80: Frontend (Nginx)
- 8000: Backend (Daphne) - internal
- 5432: PostgreSQL - internal
- 6379: Redis - internal
