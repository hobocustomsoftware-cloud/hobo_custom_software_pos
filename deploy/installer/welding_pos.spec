# PyInstaller spec - HoBo POS EXE
# Run: pyinstaller welding_pos.spec (or clean_rebuild.bat)
# DJANGO_SETTINGS_MODULE သတ်မှတ်ပြီး collect လုပ်နိုင်ရန်

import os
import sys

# PyInstaller analysis မှာ Django/DRF import လုပ်နိုင်ရန်
# __file__ may not exist when PyInstaller exec's the spec
try:
    _spec_dir = os.path.dirname(os.path.abspath(__file__))
except NameError:
    _spec_dir = os.getcwd()
_project_root = os.path.normpath(os.path.join(_spec_dir, '..', '..'))
_welding = os.path.join(_project_root, 'WeldingProject')
if _welding not in sys.path:
    sys.path.insert(0, _welding)
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WeldingProject.settings')

block_cipher = None

# collect_all for rest_framework (submodules + templates) - Django က manual hiddenimports နဲ့ပဲ
def _collect_all(pkg):
    try:
        from PyInstaller.utils.hooks import collect_all
        datas, binaries, hidden = collect_all(pkg)
        return datas, binaries, hidden
    except Exception:
        return [], [], []

_drf_datas, _drf_bin, _drf_hidden = _collect_all('rest_framework')
_dj_datas, _dj_bin, _dj_hidden = [], [], []  # Django collect_all မှာ settings error တက်တတ်လို့ skip

a = Analysis(
    ['run_exe.py'],
    pathex=[_welding],
    binaries=_drf_bin + _dj_bin,
    datas=[
        ('../../WeldingProject', 'WeldingProject'),
        ('../../assets', 'assets'),  # Central assets (logo.ico, etc.)
    ] + _drf_datas + _dj_datas,
    hiddenimports=[
        # === Django core & contrib (အကုန်ထည့်) ===
        'django', 'asgiref', 'sqlparse',
        'django.core', 'django.core.management', 'django.core.management.base',
        'django.core.handlers', 'django.core.handlers.asgi', 'django.core.handlers.wsgi',
        'django.core.wsgi', 'django.core.signals', 'django.core.checks',
        'django.conf', 'django.conf.urls', 'django.conf.urls.static',
        'django.urls', 'django.urls.resolvers', 'django.urls.base',
        'django.http', 'django.http.response', 'django.http.request',
        'django.template', 'django.template.loader', 'django.template.backends',
        'django.template.backends.django', 'django.template.context_processors',
        'django.utils', 'django.utils.functional', 'django.utils.safestring',
        'django.utils.encoding', 'django.utils.translation', 'django.utils.module_loading',
        'django.utils.deprecation', 'django.utils.log', 'django.utils.timezone',
        'django.db', 'django.db.models', 'django.db.models.fields',
        'django.db.models.query', 'django.db.models.sql', 'django.db.backends',
        'django.db.backends.sqlite3', 'django.db.backends.sqlite3.base',
        'django.db.migrations', 'django.db.transaction',
        'django.contrib.admin', 'django.contrib.admin.sites', 'django.contrib.admin.apps',
        'django.contrib.auth', 'django.contrib.auth.models', 'django.contrib.auth.backends',
        'django.contrib.auth.middleware', 'django.contrib.auth.context_processors',
        'django.contrib.contenttypes', 'django.contrib.contenttypes.models',
        'django.contrib.sessions', 'django.contrib.sessions.backends',
        'django.contrib.messages', 'django.contrib.messages.storage',
        'django.contrib.staticfiles', 'django.contrib.staticfiles.storage',
        'django.contrib.staticfiles.finders', 'django.contrib.staticfiles.handlers',
        'django.contrib.sites', 'django.contrib.sites.models',
        'django.middleware', 'django.middleware.security', 'django.middleware.common',
        'django.middleware.csrf', 'django.middleware.clickjacking',
        'django.forms', 'django.forms.models', 'django.forms.forms',
        'django.apps', 'django.apps.registry', 'django.apps.config',
        'corsheaders', 'corsheaders.middleware',
        # === Channels ===
        'channels', 'channels.layers', 'channels.apps', 'channels.db',
        'channels.generic', 'channels.generic.websocket', 'channels.routing', 'channels.security',
        'channels_redis', 'channels_redis.core',
        'daphne', 'daphne.server', 'daphne.http_protocol',
        'autobahn', 'twisted', 'hyperlink', 'txaio',
        # === Django REST Framework (အကုန်ထည့်) ===
        'rest_framework', 'rest_framework.apps', 'rest_framework.urls',
        'rest_framework.negotiation', 'rest_framework.renderers', 'rest_framework.parsers',
        'rest_framework.authentication', 'rest_framework.permissions', 'rest_framework.views',
        'rest_framework.response', 'rest_framework.generics', 'rest_framework.routers',
        'rest_framework.viewsets', 'rest_framework.decorators', 'rest_framework.status',
        'rest_framework.serializers', 'rest_framework.fields', 'rest_framework.relations',
        'rest_framework.filters', 'rest_framework.mixins', 'rest_framework.exceptions',
        'rest_framework.request', 'rest_framework.metadata', 'rest_framework.throttling',
        'rest_framework.versioning', 'rest_framework.pagination', 'rest_framework.settings',
        'rest_framework.compat', 'rest_framework.reverse', 'rest_framework.checks',
        'rest_framework.authtoken', 'rest_framework.authtoken.models',
        # rest_framework_simplejwt
        'rest_framework_simplejwt', 'rest_framework_simplejwt.views',
        'rest_framework_simplejwt.tokens', 'rest_framework_simplejwt.authentication',
        'rest_framework_simplejwt.serializers', 'rest_framework_simplejwt.backends',
        'rest_framework_simplejwt.exceptions', 'rest_framework_simplejwt.models',
        'rest_framework_simplejwt.settings', 'rest_framework_simplejwt.utils',
        'rest_framework_simplejwt.state',
        # django-filter
        'django_filters', 'django_filters.rest_framework', 'django_filters.filters',
        # drf-spectacular
        'drf_spectacular', 'drf_spectacular.utils', 'drf_spectacular.openapi',
        'drf_spectacular.views', 'drf_spectacular.generators',
        # === requirements.txt မှ packages (import names) ===
        'dj_database_url', 'psycopg2', 'PIL', 'PIL.Image', 'reportlab',
        'requests', 'uvicorn', 'uvicorn.logging', 'uvicorn.protocols',
        'uvicorn.protocols.http', 'uvicorn.protocols.http.auto',
        'uvicorn.loops', 'uvicorn.loops.auto', 'uvicorn.lifespan',
        'uvicorn.lifespan.on', 'starlette', 'starlette.routing', 'starlette.responses',
        'starlette.middleware', 'starlette.applications', 'h11', 'anyio',
        'jwt', 'markdown', 'pyyaml', 'yaml', 'inflection',
        'uritemplate', 'jsonschema', 'referencing', 'rpds_py',
        # === Project apps (WeldingProject) ===
        'core', 'core.apps', 'core.views', 'core.urls', 'core.serializers',
        'core.permissions', 'core.middleware',
        'license', 'license.apps', 'license.views', 'license.urls', 'license.middleware',
        'license.services', 'license.models', 'license.utils',
        'inventory', 'inventory.apps', 'inventory.views', 'inventory.urls',
        'inventory.serializers', 'inventory.models',
        'customer', 'customer.apps', 'customer.views', 'customer.urls',
        'customer.serializers', 'customer.models',
        'notification', 'notification.apps', 'notification.middleware',
        'notification.consumers', 'notification.routing',
        'service', 'service.apps', 'service.views', 'service.urls',
        'service.serializers', 'service.models',
    ] + _drf_hidden + _dj_hidden,
    hookspath=['.'],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

_logo_ico = os.path.join(_spec_dir, 'logo.ico')
exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='HoBoPOS',
    icon=_logo_ico if os.path.exists(_logo_ico) else None,
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,  # No CMD window - browser only
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
