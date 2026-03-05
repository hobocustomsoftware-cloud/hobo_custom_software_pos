#!/bin/bash
# Cron script to fetch exchange rates daily at 10:00 AM
# Add to crontab: 0 10 * * * /path/to/fetch_exchange_rates_cron.sh

# Set working directory
cd "$(dirname "$0")/../../WeldingProject" || exit 1

# Activate virtual environment if exists
if [ -f "../venv/bin/activate" ]; then
    source ../venv/bin/activate
elif [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
fi

# Run Django management command
python manage.py fetch_exchange_rates

# Log result
echo "$(date): Exchange rate fetch completed" >> /var/log/hobopos-exchange-rate.log 2>&1
