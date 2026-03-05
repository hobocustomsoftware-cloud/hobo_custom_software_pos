# Installation Module - Complete Implementation

## ✅ Implementation Complete

### Backend (Django)

#### Models Created:
- **InstallationJob** (`installation/models.py`)
  - Links to SaleTransaction (Bundle or Product sale)
  - Customer from sale transaction
  - Installation address, dates
  - Technician assignment (User with Technician role)
  - Status: pending → in_progress → completed → signed_off
  - Signature capture (ImageField)
  - Auto-generated installation number (INST-YYMMDD-XXXX)
  - Status history tracking

- **InstallationStatusHistory** (`installation/models.py`)
  - Tracks all status changes
  - Notes and updated_by user

#### API Endpoints (`/api/installation/`):
- `GET /api/installation/jobs/` - List installations (with filters: status, technician, active_only)
- `POST /api/installation/jobs/` - Create installation job
- `GET /api/installation/jobs/{id}/` - Get installation details
- `PUT /api/installation/jobs/{id}/` - Update installation
- `PATCH /api/installation/jobs/{id}/` - Partial update
- `DELETE /api/installation/jobs/{id}/` - Delete installation
- `POST /api/installation/jobs/{id}/update-status/` - Update status with history
- `POST /api/installation/jobs/{id}/upload-signature/` - Upload customer signature
- `GET /api/installation/jobs/{id}/warranty-sync/` - Manually sync warranty dates
- `GET /api/installation/dashboard/` - Dashboard with statistics and active jobs

#### Signals (`installation/signals.py`):
- Auto-create status history on creation
- Optional: Auto-create installation job on approved sale (commented out, can be enabled)

#### Warranty Sync Logic:
- When installation status changes to 'completed':
  - Automatically syncs warranty_start_date to today for all serial items in the sale
  - Updates WarrantyRecord with new start/end dates
  - Only processes products with warranty_months > 0

#### Settings Updated:
- Added `installation.apps.InstallationConfig` to `INSTALLED_APPS`
- Added installation URLs to main `urls.py`

### Frontend (Vue.js)

#### Pages Created:
1. **InstallationManagement.vue** (`/installation`)
   - Full CRUD for installation jobs
   - Filter by status, active only
   - Create/Edit modal
   - List view with all details

2. **InstallationDashboard.vue** (`/installation/dashboard`)
   - Statistics: Total Active, Pending, In Progress, Completed
   - Active installations list
   - Quick view and navigation

3. **InstallationDetail.vue** (`/installation/:id`)
   - View full installation details
   - Update technician, status, description, notes
   - Signature capture/upload
   - Status history display

4. **SignatureCapture.vue**
   - Canvas-based signature drawing
   - File upload alternative
   - Save as image file

#### Router Updated:
- Added routes:
  - `/installation` - Management page
  - `/installation/dashboard` - Dashboard
  - `/installation/:id` - Detail page

#### Sidebar Updated:
- Added menu items:
  - "တပ်ဆင်မှု Dashboard" (for managers)
  - "တပ်ဆင်မှု စီမံခန့်ခွဲမှု" (for managers/inventory managers)

## Features Implemented

### ✅ Link with Sales
- Installation jobs can be created from approved sales
- Links to SaleTransaction via ForeignKey
- Customer automatically pulled from sale transaction

### ✅ Technician Assignment
- Dropdown to select technician
- Filters users by role containing "technician"
- Can update technician after creation

### ✅ Status Tracking
- Status flow: Pending → In Progress → Completed → Signed Off
- Status history automatically tracked
- Can cancel installations

### ✅ Signature Capture
- Canvas-based signature drawing
- File upload alternative
- Saves as image file
- Auto-updates status to "signed_off" when signature uploaded

### ✅ Warranty Sync
- Automatically syncs warranty dates when status changes to "completed"
- Sets warranty_start_date to today
- Calculates warranty_end_date based on product warranty_months
- Updates existing WarrantyRecord or creates new one

### ✅ Dashboard
- Statistics overview
- Active installations list
- Filter and view capabilities

## Database Migration

Migration file created: `installation/migrations/0001_initial.py`

To apply:
```bash
python manage.py makemigrations installation
python manage.py migrate installation
```

## Usage

### Creating Installation Job:
1. Go to `/installation`
2. Click "+ အသစ်ထည့်ရန်"
3. Select approved sale (invoice)
4. Fill installation address, date, technician
5. Save

### Updating Status:
1. View installation detail
2. Select new status from dropdown
3. Click "Update"
4. Status history automatically recorded

### Signature Capture:
1. When status is "completed"
2. Draw signature on canvas OR upload image
3. Click "Save Signature"
4. Status automatically changes to "signed_off"

### Warranty Sync:
- Automatic: When status changes to "completed"
- Manual: Use `/api/installation/jobs/{id}/warranty-sync/` endpoint

## API Examples

### Create Installation:
```bash
POST /api/installation/jobs/
{
  "sale_transaction": 123,
  "installation_address": "123 Main St",
  "installation_date": "2026-02-20",
  "estimated_completion_date": "2026-02-25",
  "technician": 5,
  "description": "Solar panel installation"
}
```

### Update Status:
```bash
POST /api/installation/jobs/1/update-status/
{
  "status": "completed",
  "notes": "Installation completed successfully"
}
```

### Upload Signature:
```bash
POST /api/installation/jobs/1/upload-signature/
FormData: { signature: <file> }
```

## Role Permissions

- **Manager/Admin/Owner**: Full access to all installation features
- **Inventory Manager**: Can view and manage installations
- **Technician**: Can be assigned to installations (via role filter)

## Next Steps

1. Run migrations:
   ```bash
   python manage.py makemigrations installation
   python manage.py migrate
   ```

2. Create Technician role (if not exists):
   - Go to User Management → Roles
   - Create role with name containing "technician"
   - Assign to users who will be technicians

3. Test the module:
   - Create a test sale
   - Create installation job from that sale
   - Update status through workflow
   - Test signature capture
   - Verify warranty sync

## Files Created/Modified

### Backend:
- `WeldingProject/installation/__init__.py`
- `WeldingProject/installation/apps.py`
- `WeldingProject/installation/models.py`
- `WeldingProject/installation/serializers.py`
- `WeldingProject/installation/views.py`
- `WeldingProject/installation/urls.py`
- `WeldingProject/installation/signals.py`
- `WeldingProject/installation/admin.py`
- `WeldingProject/installation/migrations/0001_initial.py`
- `WeldingProject/WeldingProject/settings.py` (updated)
- `WeldingProject/WeldingProject/urls.py` (updated)

### Frontend:
- `yp_posf/src/views/installation/InstallationManagement.vue`
- `yp_posf/src/views/installation/InstallationDashboard.vue`
- `yp_posf/src/views/installation/InstallationDetail.vue`
- `yp_posf/src/views/installation/SignatureCapture.vue`
- `yp_posf/src/router/index.js` (updated)
- `yp_posf/src/components/Sidebar.vue` (updated)

## Status: ✅ COMPLETE

All features implemented and ready for testing!
