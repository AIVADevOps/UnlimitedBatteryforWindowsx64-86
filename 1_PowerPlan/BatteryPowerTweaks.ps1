# ================================================
# BATTERY POWER TWEAKS - Advanced Settings
# Run as Administrator
# ================================================

$plan = "11111111-2222-3333-4444-555566667777"  # AMD Battery Max

Write-Host "Applying advanced battery tweaks..." -ForegroundColor Cyan

# --- USB Selective Suspend (Enable) ---
powercfg -setdcvalueindex $plan 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
Write-Host "[OK] USB Selective Suspend: Enabled" -ForegroundColor Green

# --- USB Hub Selective Suspend ---
powercfg -setdcvalueindex $plan 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 1
Write-Host "[OK] USB Hub Suspend: Enabled" -ForegroundColor Green

# --- AHCI Link Power Management (Max Savings) ---
powercfg -setdcvalueindex $plan 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 3
Write-Host "[OK] AHCI Link Power: Max Savings" -ForegroundColor Green

# --- NVMe Power State Transition (Lowest Latency Tolerance) ---
powercfg -setdcvalueindex $plan 0012ee47-9041-4b5d-9b77-535fba8b1442 fc95af4d-40e7-4b6d-835a-56d131dbc80e 1
Write-Host "[OK] NVMe Power: Low Latency" -ForegroundColor Green

# --- Processor Idle Demote/Promote Threshold ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 20
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 60
Write-Host "[OK] Processor Idle Thresholds: Optimized" -ForegroundColor Green

# --- System Cooling Policy (Passive = less fan, throttle first) ---
powercfg -setdcvalueindex $plan 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 0
Write-Host "[OK] Cooling Policy: Passive" -ForegroundColor Green

# --- Display Brightness Dimmed (40%) ---
powercfg -setdcvalueindex $plan 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 40
Write-Host "[OK] Dimmed Brightness: 40%" -ForegroundColor Green

# --- Adaptive Display Timeout ---
powercfg -setdcvalueindex $plan 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 1
Write-Host "[OK] Adaptive Display: Enabled" -ForegroundColor Green

# --- Hard Disk Timeout (1 minute) ---
powercfg -setdcvalueindex $plan 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 60
Write-Host "[OK] Disk Timeout: 60s" -ForegroundColor Green

# --- Wireless Adapter Power (Max Savings) ---
powercfg -setdcvalueindex $plan 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 3
Write-Host "[OK] WiFi Power: Max Savings" -ForegroundColor Green

# --- Activate the plan ---
powercfg -setactive $plan
Write-Host "`n[DONE] All tweaks applied!" -ForegroundColor Cyan
