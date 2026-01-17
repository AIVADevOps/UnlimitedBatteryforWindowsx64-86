# ================================================
# BATTERY OPTIMIZATION - Services & Scheduled Tasks
# Run as Administrator
# ================================================

Write-Host "=== DISABLING SERVICES ===" -ForegroundColor Cyan

$services = @(
    "DiagTrack",           # Telemetry
    "WSearch",             # Windows Search
    "MapsBroker",          # Offline Maps
    "RetailDemo",          # Retail Demo
    "dmwappushservice",    # Push Messages
    "lfsvc",               # Geolocation
    "WMPNetworkSvc",       # Windows Media Sharing
    "WerSvc",              # Error Reporting
    "Fax",                 # Fax Service
    "XblAuthManager",      # Xbox Auth
    "XblGameSave",         # Xbox Game Save
    "XboxNetApiSvc",       # Xbox Networking
    "XboxGipSvc"           # Xbox Accessories
)

foreach ($svc in $services) {
    $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($service) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "[OK] $svc disabled" -ForegroundColor Green
    } else {
        Write-Host "[--] $svc not found" -ForegroundColor Gray
    }
}

Write-Host "`n=== DISABLING SCHEDULED TASKS ===" -ForegroundColor Cyan

$tasks = @(
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\Feedback\Siuf\DmClient",
    "\Microsoft\Windows\Maps\MapsToastTask",
    "\Microsoft\Windows\Maps\MapsUpdateTask",
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem",
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
    "\Microsoft\Windows\Application Experience\StartupAppTask",
    "\Microsoft\Windows\DiskFootprint\Diagnostics",
    "\Microsoft\Windows\PI\Sqm-Tasks"
)

foreach ($task in $tasks) {
    try {
        Disable-ScheduledTask -TaskName $task -ErrorAction Stop | Out-Null
        Write-Host "[OK] $task disabled" -ForegroundColor Green
    } catch {
        Write-Host "[--] $task not found or already disabled" -ForegroundColor Gray
    }
}

Write-Host "`n=== ADDITIONAL POWER SETTINGS ===" -ForegroundColor Cyan

$plan = "11111111-2222-3333-4444-555566667777"

# Display Timeout (2 minutes on battery)
powercfg -setdcvalueindex $plan 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 120
Write-Host "[OK] Display Timeout: 2 min" -ForegroundColor Green

# Sleep Timeout (5 minutes on battery)
powercfg -setdcvalueindex $plan 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 300
Write-Host "[OK] Sleep Timeout: 5 min" -ForegroundColor Green

# Processor Idle State Maximum (enable deepest C-states)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
Write-Host "[OK] Deep C-States: Enabled" -ForegroundColor Green

# Heterogeneous Thread Policy (Prefer efficiency)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 0
Write-Host "[OK] Thread Policy: Efficiency" -ForegroundColor Green

# Processor Performance Time Check Interval (longer = less overhead)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 30
Write-Host "[OK] Performance Check Interval: 30ms" -ForegroundColor Green

# Activate plan
powercfg -setactive $plan

Write-Host "`n=== ALL DONE ===" -ForegroundColor Cyan
Write-Host "Disabled: Services, Scheduled Tasks, Applied Power Settings" -ForegroundColor Green
Write-Host "Restart recommended for full effect." -ForegroundColor Yellow
