# Realtek RTL8852BE WiFi Performance Fix
# Run as Administrator
# Source: https://fixconnecting.com/network-devices/realtek-rtl8852be-wi-fi-issues/

Write-Host "=== Realtek RTL8852BE WiFi Fix ===" -ForegroundColor Cyan

# 1. Find Realtek adapter in registry and disable LpsEn (Low Power State)
Write-Host "`n[1/4] Disabling LpsEn (Low Power State)..." -ForegroundColor Yellow
$regPath = "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
$found = $false

Get-ChildItem $regPath -ErrorAction SilentlyContinue | ForEach-Object {
    $props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
    if ($props.DriverDesc -like "*Realtek*" -or $props.DriverDesc -like "*RTL*") {
        $adapterPath = $_.PSPath
        Write-Host "Found: $($props.DriverDesc)" -ForegroundColor Gray

        # Disable LpsEn (Low Power State Enable) - 0 = disabled
        if ($null -ne $props.LpsEn) {
            Set-ItemProperty -Path $adapterPath -Name "LpsEn" -Value 0 -ErrorAction SilentlyContinue
            Write-Host "[OK] LpsEn set to 0 (disabled)" -ForegroundColor Green
        }

        # Disable power saving features
        Set-ItemProperty -Path $adapterPath -Name "PnPCapabilities" -Value 24 -Type DWord -ErrorAction SilentlyContinue
        Write-Host "[OK] PnPCapabilities set (disable power off)" -ForegroundColor Green

        $found = $true
    }
}

if (-not $found) {
    Write-Host "[SKIP] Realtek adapter not found in registry" -ForegroundColor Yellow
}

# 2. Disable Microsoft Wi-Fi Direct Virtual Adapters
Write-Host "`n[2/4] Disabling Wi-Fi Direct Virtual Adapters..." -ForegroundColor Yellow
Get-PnpDevice -FriendlyName "*Wi-Fi Direct*" -ErrorAction SilentlyContinue | ForEach-Object {
    Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "[OK] Disabled: $($_.FriendlyName)" -ForegroundColor Green
}

# 3. Set adapter advanced properties for max performance
Write-Host "`n[3/4] Setting adapter for max performance..." -ForegroundColor Yellow
Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Preferred Band" -DisplayValue "3. 5G first" -ErrorAction SilentlyContinue
Write-Host "[OK] Preferred Band: 5GHz first" -ForegroundColor Green

Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Roaming Sensitivity Level" -DisplayValue "Low" -ErrorAction SilentlyContinue
Write-Host "[OK] Roaming Sensitivity: Low" -ForegroundColor Green

Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Leerlauf-Energiesparen" -DisplayValue "Low" -ErrorAction SilentlyContinue
Write-Host "[OK] Idle Power Saving: Low" -ForegroundColor Green

# 4. Power Plan WiFi setting
Write-Host "`n[4/4] Setting Power Plan WiFi to Max Performance..." -ForegroundColor Yellow
powercfg -setdcvalueindex 11111111-2222-3333-4444-555566667777 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
powercfg -setacvalueindex 11111111-2222-3333-4444-555566667777 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
powercfg -setactive 11111111-2222-3333-4444-555566667777
Write-Host "[OK] WiFi Power: Maximum Performance" -ForegroundColor Green

Write-Host "`n=== DONE ===" -ForegroundColor Cyan
Write-Host "RESTART REQUIRED for full effect!" -ForegroundColor Red
Write-Host ""
Write-Host "If WiFi is still slow after restart:" -ForegroundColor Yellow
Write-Host "1. Update Realtek driver from laptop manufacturer" -ForegroundColor White
Write-Host "2. Connect to 5GHz network only" -ForegroundColor White
Write-Host "3. Disable Smart Connect on router" -ForegroundColor White
