# WiFi Maximum Performance Script
# Run as Administrator

Write-Host "=== WiFi Maximum Performance ===" -ForegroundColor Cyan

# 1. Leerlauf-Energiesparen auf Low (niedrigste verfügbare Option)
Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Leerlauf-Energiesparen" -DisplayValue "Low"
Write-Host "[OK] Idle Power Saving: Low (minimum)" -ForegroundColor Green

# 2. Roaming Sensitivity auf Low (weniger Scanning = stabiler)
Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Roaming Sensitivity Level" -DisplayValue "Low"
Write-Host "[OK] Roaming Sensitivity: Low (stable connection)" -ForegroundColor Green

# 3. Throughput Booster (falls verfügbar)
$tb = Get-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "*Throughput*" -ErrorAction SilentlyContinue
if ($tb) {
    Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName $tb.DisplayName -DisplayValue "Enabled"
    Write-Host "[OK] Throughput Booster: Enabled" -ForegroundColor Green
}

# 4. U-APSD deaktivieren (Power Save Feature das Latenz verursacht)
$uapsd = Get-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "*U-APSD*" -ErrorAction SilentlyContinue
if ($uapsd) {
    Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName $uapsd.DisplayName -DisplayValue "Disabled"
    Write-Host "[OK] U-APSD: Disabled (reduces latency)" -ForegroundColor Green
}

Write-Host "`n=== Done ===" -ForegroundColor Cyan
Write-Host "WiFi is now set for maximum streaming performance" -ForegroundColor Green
