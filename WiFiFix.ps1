# WiFi Fix Script - Run as Administrator
# Fixes WiFi connectivity issues while saving battery

Write-Host "=== WiFi Power Settings Fix ===" -ForegroundColor Cyan

# Disable Wake on Magic Packet (saves battery, not needed for most users)
Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Wake on Magic Packet" -DisplayValue "Deaktivieren"
Write-Host "[OK] Wake on Magic Packet: Disabled" -ForegroundColor Green

# Disable Wake on Pattern Match (saves battery)
Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Wake on Pattern Match" -DisplayValue "Deaktivieren"
Write-Host "[OK] Wake on Pattern Match: Disabled" -ForegroundColor Green

# Set Idle Power Saving to Low (prevents WiFi disconnects)
Set-NetAdapterAdvancedProperty -Name "WLAN" -DisplayName "Leerlauf-Energiesparen" -DisplayValue "Low"
Write-Host "[OK] Idle Power Saving: Low" -ForegroundColor Green

Write-Host "`n=== Done ===" -ForegroundColor Cyan
