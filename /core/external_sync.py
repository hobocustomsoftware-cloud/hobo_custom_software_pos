"""
Sync new user registration to Google Sheet and send Telegram notification.
Uses .env: TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID, GOOGLE_SHEETS_*.
Failures are logged but do not block registration.
"""
import logging
from django.conf import settings

logger = logging.getLogger(__name__)


def _send_telegram(message: str) -> bool:
    token = getattr(settings, 'TELEGRAM_BOT_TOKEN', None) or ''
    chat_id = getattr(settings, 'TELEGRAM_CHAT_ID', None) or ''
    if not token or not chat_id:
        return False
    try:
        import requests
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        r = requests.post(url, json={"chat_id": chat_id, "text": message}, timeout=10)
        if r.status_code != 200:
            logger.warning("Telegram send failed: %s %s", r.status_code, r.text)
            return False
        return True
    except Exception as e:
        logger.warning("Telegram send error: %s", e)
        return False


def _append_to_google_sheet(row: list) -> bool:
    spreadsheet_id = getattr(settings, 'GOOGLE_SHEETS_SPREADSHEET_ID', None) or ''
    sheet_name = getattr(settings, 'GOOGLE_SHEETS_SHEET_NAME', None) or 'Registrations'
    creds_path = getattr(settings, 'GOOGLE_SHEETS_CREDENTIALS_JSON', None) or ''
    if not spreadsheet_id or not creds_path:
        return False
    try:
        import json
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
        from googleapiclient.errors import HttpError

        scopes = ['https://www.googleapis.com/auth/spreadsheets']
        with open(creds_path, 'r') as f:
            info = json.load(f)
        credentials = service_account.Credentials.from_service_account_info(info, scopes=scopes)
        service = build('sheets', 'v4', credentials=credentials)
        body = {'values': [row]}
        service.spreadsheets().values().append(
            spreadsheetId=spreadsheet_id,
            range=f"'{sheet_name}'!A:Z",
            valueInputOption='USER_ENTERED',
            body=body,
        ).execute()
        return True
    except ImportError:
        logger.warning("Google Sheets sync skipped: install google-auth and google-api-python-client")
        return False
    except Exception as e:
        logger.warning("Google Sheet append error: %s", e)
        return False


def sync_new_registration(user, shop_name: str = ''):
    """
    Call after a new user is registered (phone-based or email).
    Sends Telegram notification and appends row to Google Sheet if configured.
    """
    full_name = f"{getattr(user, 'first_name', '') or ''} {getattr(user, 'last_name', '') or ''}".strip() or user.username
    phone = getattr(user, 'phone_number', None) or ''
    email = getattr(user, 'email', None) or ''

    message = f"New Signup: {full_name}, Phone: {phone}, Shop: {shop_name or '-'}"
    _send_telegram(message)

    from django.utils import timezone
    row = [
        timezone.now().isoformat(),
        full_name,
        phone,
        email,
        shop_name or '',
        user.username,
    ]
    _append_to_google_sheet(row)
