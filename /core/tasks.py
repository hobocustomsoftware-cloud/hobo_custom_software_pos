"""
Celery tasks for core app. Registration sync (Google Sheet + Telegram) runs in background.
"""
import logging
from celery import shared_task

logger = logging.getLogger(__name__)


@shared_task(name='core.sync_new_signup_marketing', bind=True)
def sync_new_signup_marketing(self, user_id: int, shop_name: str = ''):
    """
    Background task: sync new shop registration to Google Sheet and send Telegram notification.
    Message: "New Signup: {name}, Phone: {phone}, Shop: {shop_name}".
    """
    from django.contrib.auth import get_user_model
    from .external_sync import _send_telegram, _append_to_google_sheet
    from django.utils import timezone

    User = get_user_model()
    try:
        user = User.objects.get(pk=user_id)
    except User.DoesNotExist:
        logger.warning("sync_new_signup_marketing: user_id=%s not found", user_id)
        return

    name = f"{getattr(user, 'first_name', '') or ''} {getattr(user, 'last_name', '') or ''}".strip() or user.username
    phone = getattr(user, 'phone_number', None) or ''
    shop = (shop_name or '').strip() or '-'

    message = f"New Signup: {name}, Phone: {phone}, Shop: {shop}"
    _send_telegram(message)

    row = [
        timezone.now().isoformat(),
        name,
        phone,
        getattr(user, 'email', None) or '',
        shop,
        user.username,
    ]
    _append_to_google_sheet(row)
