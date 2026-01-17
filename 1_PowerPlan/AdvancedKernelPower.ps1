# ================================================
# ADVANCED KERNEL POWER SETTINGS
# Hidden PowerCfg Tweaks
# ================================================

$plan = "11111111-2222-3333-4444-555566667777"

Write-Host "=== UNHIDING ADVANCED POWER SETTINGS ===" -ForegroundColor Cyan

# Unhide all hidden power settings (Attributes = 2 means hidden)
$powerSettings = @(
    # Processor Idle Settings
    "54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad",  # Processor Idle Disable
    "54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb",  # Idle Promote Threshold
    "54533251-82be-4824-96c1-47b60b740d00\36687f9e-e3a5-4dbf-b1dc-15eb381c6863",  # Idle Demote Threshold
    "54533251-82be-4824-96c1-47b60b740d00\c4581c31-89ab-4597-8e2b-9c9cab440e6b",  # Idle State Maximum
    "54533251-82be-4824-96c1-47b60b740d00\9943e905-9a30-4ec1-9b99-44dd3b76f7a2",  # Idle Time Check
    # Processor Parking
    "54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583",  # Core Parking Min Cores
    "54533251-82be-4824-96c1-47b60b740d00\ea062031-0e34-4ff1-9b6d-eb1059334028",  # Core Parking Max Cores
    "54533251-82be-4824-96c1-47b60b740d00\f735a673-2066-4f80-a0c5-ddee0cf1bf5d",  # Core Parking Concurrency Threshold
    # Latency Sensitivity
    "54533251-82be-4824-96c1-47b60b740d00\619b7505-003b-4e82-b7a6-4dd29c300971",  # Latency Sensitivity Hint
    # Heterogeneous Policy (Efficiency cores)
    "54533251-82be-4824-96c1-47b60b740d00\7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5",  # Heterogeneous Thread Policy
    "54533251-82be-4824-96c1-47b60b740d00\4bdaf4e9-d103-46d7-a5f0-6280121616ef",  # Short vs Long Thread Policy
    # Energy Performance
    "54533251-82be-4824-96c1-47b60b740d00\36687f9e-e3a5-4dbf-b1dc-15eb381c6864"   # Energy Performance Preference
)

foreach ($setting in $powerSettings) {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\$setting"
    if (Test-Path $regPath) {
        Set-ItemProperty -Path $regPath -Name "Attributes" -Value 0 -ErrorAction SilentlyContinue
    }
}
Write-Host "[OK] Hidden power settings exposed" -ForegroundColor Green

Write-Host "`n=== APPLYING ADVANCED BATTERY SETTINGS ===" -ForegroundColor Cyan

# --- Processor Idle Thresholds (More aggressive idling) ---
# Idle Demote Threshold (Lower = faster drop to deeper C-state)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 10
Write-Host "[OK] Idle Demote Threshold: 10%" -ForegroundColor Green

# Idle Promote Threshold (Higher = stay in deep C-state longer)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 80
Write-Host "[OK] Idle Promote Threshold: 80%" -ForegroundColor Green

# --- Idle Time Check (Less frequent = less overhead) ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 50000
Write-Host "[OK] Idle Time Check: 50ms" -ForegroundColor Green

# --- Core Parking (Aggressive for battery) ---
# Min Cores (Lower = more parking allowed)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 10
Write-Host "[OK] Core Parking Min Cores: 10%" -ForegroundColor Green

# Concurrency Threshold (Higher = park sooner)
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 90
Write-Host "[OK] Core Parking Concurrency: 90%" -ForegroundColor Green

# --- Latency Sensitivity (Prefer power over latency) ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 0
Write-Host "[OK] Latency Sensitivity: Power Mode" -ForegroundColor Green

# --- Heterogeneous Thread Policy (Prefer efficiency cores) ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 0
Write-Host "[OK] Thread Policy: Efficiency Cores" -ForegroundColor Green

# --- Processor Performance Decrease Policy (Aggressive) ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1
Write-Host "[OK] Performance Decrease: Aggressive" -ForegroundColor Green

# --- Processor Performance Increase Policy (Gradual) ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2
Write-Host "[OK] Performance Increase: Gradual" -ForegroundColor Green

# --- Activate Plan ---
powercfg -setactive $plan

Write-Host "`n=== KERNEL SETTINGS SUMMARY ===" -ForegroundColor Cyan
Write-Host "- Deep C-States: Aggressive entry" -ForegroundColor White
Write-Host "- Core Parking: 90% can be parked" -ForegroundColor White
Write-Host "- Latency: Power over speed" -ForegroundColor White
Write-Host "- Frequency Scaling: Quick down, slow up" -ForegroundColor White
Write-Host "`nRestart required for full effect." -ForegroundColor Yellow
