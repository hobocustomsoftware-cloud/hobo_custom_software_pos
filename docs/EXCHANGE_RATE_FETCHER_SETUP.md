# Exchange Rate Fetcher Setup Guide

## Overview
Automated daily exchange rate fetching from CBM API (https://forex.cbm.gov.mm/api/latest) with manual adjustment capabilities.

---

## Features

1. **Multi-Currency Support**: USD, THB, SGD
2. **Automatic Fetching**: Daily at 10:00 AM
3. **Fallback Logic**: Uses last recorded rate if API is down
4. **Manual Adjustments**: Market Premium % or Manual Fixed Rate
5. **Admin Dashboard**: UI for managing rate adjustments

---

## Setup Options

### Option 1: Celery (Recommended for Production)

#### 1. Install Dependencies
```bash
pip install celery redis
```

#### 2. Start Redis
```bash
# Docker
docker run -d -p 6379:6379 redis:7-alpine

# Or use existing Redis from docker-compose.yml
```

#### 3. Start Celery Worker
```bash
cd WeldingProject
celery -A WeldingProject worker --loglevel=info
```

#### 4. Start Celery Beat (Scheduler)
```bash
cd WeldingProject
celery -A WeldingProject beat --loglevel=info
```

#### 5. Verify Task Schedule
The task `inventory.fetch_exchange_rates_daily` is scheduled to run daily at 10:00 AM (Asia/Yangon timezone).

---

### Option 2: Cron Script (Simple Alternative)

#### Windows (Task Scheduler)

1. Open **Task Scheduler**
2. Create **Basic Task**
3. Name: "HoBo POS - Fetch Exchange Rates"
4. Trigger: **Daily at 10:00 AM**
5. Action: **Start a program**
   - Program: `powershell.exe`
   - Arguments: `-File "F:\hobo_license_pos\deploy\scripts\fetch_exchange_rates_cron.ps1"`
6. Save

#### Linux/Mac (Cron)

1. Edit crontab:
   ```bash
   crontab -e
   ```

2. Add line:
   ```bash
   0 10 * * * /path/to/deploy/scripts/fetch_exchange_rates_cron.sh >> /var/log/hobopos-exchange-rate.log 2>&1
   ```

3. Make script executable:
   ```bash
   chmod +x deploy/scripts/fetch_exchange_rates_cron.sh
   ```

---

## Manual Testing

### Test the Fetcher Command
```bash
cd WeldingProject
python manage.py fetch_exchange_rates --test
```

### Force Update (Even if Rate Exists)
```bash
python manage.py fetch_exchange_rates --force
```

---

## Admin Dashboard Usage

### Access Exchange Rate Settings
1. Login as Owner/Admin
2. Go to **Settings** page
3. Find **Exchange Rate Settings** section
4. Click to expand

### Manual Adjustments

#### Market Premium Percentage
- Example: Set `10` to add 10% markup to CBM rate
- Formula: `Final Rate = CBM Rate × (1 + Premium/100)`
- Use case: Add market premium to cover costs

#### Manual Fixed Rate
- Overrides CBM rate completely
- Use case: Set custom rate regardless of CBM
- Priority: Higher than Market Premium %

### Fetch Rates Now
- Click **"🔄 Fetch Rates Now"** button
- Manually triggers rate fetch from CBM API
- Updates all currencies (USD, THB, SGD)

---

## API Endpoints

### Get Current Rates
```
GET /api/settings/exchange-rate/history/?limit=3
```

### Get Rate History
```
GET /api/settings/exchange-rate/history/?days=7
```

### Fetch Rates Now
```
POST /api/settings/exchange-rate/fetch/
```

### Get Adjustments
```
GET /api/settings/exchange-rate/adjustments/
```

### Save Adjustments
```
POST /api/settings/exchange-rate/adjustments/
{
  "usd": {
    "market_premium_percentage": 10,
    "manual_fixed_rate": null
  },
  "thb": {
    "market_premium_percentage": null,
    "manual_fixed_rate": 50.5
  },
  "sgd": {
    "market_premium_percentage": 5,
    "manual_fixed_rate": null
  }
}
```

---

## Database Models

### ExchangeRateLog
- `date`: Date of rate
- `currency`: USD, THB, or SGD
- `rate`: Rate value (MMK per unit)
- `source`: CBM, Manual, or Fallback

### GlobalSetting (Enhanced)
- `market_premium_percentage`: Percentage markup (e.g., 10 = +10%)
- `manual_fixed_rate`: Override rate (if set, ignores CBM)

---

## Fallback Logic

1. **API Available**: Fetch from CBM → Apply adjustments → Save
2. **API Down**: Use last recorded rate from ExchangeRateLog
3. **No History**: Use rate from GlobalSetting (for USD)
4. **No Settings**: Log error, skip update

---

## Rate Calculation Priority

1. **Manual Fixed Rate** (if set) → Use this rate
2. **Market Premium %** (if set) → CBM Rate × (1 + Premium/100)
3. **CBM Rate** → Use as-is

---

## Monitoring

### Check Logs
- Celery: Check worker logs
- Cron: Check `/var/log/hobopos-exchange-rate.log` (Linux) or `logs\exchange-rate-fetch.log` (Windows)

### Verify Rates
```bash
python manage.py shell
>>> from inventory.models import ExchangeRateLog
>>> ExchangeRateLog.objects.filter(currency='USD').order_by('-date')[:5]
```

---

## Troubleshooting

### Rates Not Updating
1. Check Celery worker is running
2. Check Celery beat is running
3. Check Redis connection
4. Check CBM API is accessible
5. Check logs for errors

### Manual Rate Not Applied
1. Verify GlobalSetting is saved correctly
2. Check `market_premium_percentage` or `manual_fixed_rate` fields
3. Verify key matches currency (e.g., `usd_exchange_rate`)

### API Errors
- CBM API may be temporarily down
- Fallback will use last recorded rate
- Check network connectivity

---

## Production Deployment

### Docker Compose
Add to `docker-compose.yml`:
```yaml
celery_worker:
  build: ./WeldingProject
  command: celery -A WeldingProject worker --loglevel=info
  depends_on:
    - redis
  environment:
    - REDIS_URL=redis://redis:6379/0

celery_beat:
  build: ./WeldingProject
  command: celery -A WeldingProject beat --loglevel=info
  depends_on:
    - redis
  environment:
    - REDIS_URL=redis://redis:6379/0
```

---

## Next Steps

1. Run migrations: `python manage.py migrate`
2. Test command: `python manage.py fetch_exchange_rates --test`
3. Set up Celery or Cron
4. Configure manual adjustments in Admin Dashboard
5. Monitor logs for successful fetches
