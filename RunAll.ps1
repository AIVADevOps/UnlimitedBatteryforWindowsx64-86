# ================================================================
# BATTERY OPTIMIZATIONS - MASTER SCRIPT
# Run as Administrator
# ================================================================

$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   BATTERY OPTIMIZATIONS - MASTER SCRIPT   " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 1. Power Plan Settings
Write-Host "[1/5] Applying Power Plan Settings..." -ForegroundColor Yellow
& "$basePath\1_PowerPlan\BatteryPowerTweaks.ps1"
& "$basePath\1_PowerPlan\AdvancedKernelPower.ps1"

# 2. Registry Tweaks
Write-Host "`n[2/5] Importing Registry Tweaks..." -ForegroundColor Yellow
Start-Process regedit -ArgumentList "/s `"$basePath\2_Registry\BatteryRegistryTweaks.reg`"" -Wait
Start-Process regedit -ArgumentList "/s `"$basePath\2_Registry\AdvancedKernelBattery.reg`"" -Wait
Start-Process regedit -ArgumentList "/s `"$basePath\2_Registry\ChromeEfficiency.reg`"" -Wait
Start-Process regedit -ArgumentList "/s `"$basePath\2_Registry\SpotifyDiscordEfficiency.reg`"" -Wait
Write-Host "[OK] Registry tweaks imported" -ForegroundColor Green

# 3. Services & Tasks
Write-Host "`n[3/5] Disabling Services & Tasks..." -ForegroundColor Yellow
& "$basePath\3_Services\BatteryServicesAndTasks.ps1"
& "$basePath\3_Services\BatteryTweaks2.ps1"

# 4. Process Priority (for running apps)
Write-Host "`n[4/5] Setting Process Priorities..." -ForegroundColor Yellow
& "$basePath\4_ProcessPriority\SetEfficiencyMode.ps1"

# 5. WiFi Fix
Write-Host "`n[5/5] Applying WiFi Power Fix..." -ForegroundColor Yellow
& "$basePath\WiFiFix.ps1"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   ALL OPTIMIZATIONS APPLIED!              " -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   UXTU Profil: Snapdragon+                " -ForegroundColor Yellow
Write-Host "   - STAPM/Slow/Fast: 8W                   " -ForegroundColor White
Write-Host "   - CPU EDC: 50A (smooth UI)              " -ForegroundColor White
Write-Host "   - iGPU: 750MHz                          " -ForegroundColor White
Write-Host "   - Undervolt: -50/-50                    " -ForegroundColor White
Write-Host ""
Write-Host "   Restart recommended for full effect.    " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
