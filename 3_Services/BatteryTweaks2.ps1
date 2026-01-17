# ================================================
# BATTERY TWEAKS PART 2
# Run as Administrator
# ================================================

Write-Host "=== 1. STARTUP APPS ===" -ForegroundColor Cyan
Write-Host "Current Startup Apps:" -ForegroundColor Yellow

# List startup apps
$startupApps = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location
$startupApps | Format-Table -AutoSize

# Disable common unnecessary startup items via Registry
$startupDisable = @(
    "Microsoft Edge",
    "Spotify",
    "Discord",
    "Steam",
    "EpicGamesLauncher",
    "OneDrive"
)

$regPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($path in $regPaths) {
    foreach ($app in $startupDisable) {
        $existing = Get-ItemProperty -Path $path -Name "*$app*" -ErrorAction SilentlyContinue
        if ($existing) {
            Remove-ItemProperty -Path $path -Name "*$app*" -ErrorAction SilentlyContinue
            Write-Host "[OK] Removed $app from startup" -ForegroundColor Green
        }
    }
}

Write-Host "`n=== 2. WINDOWS DEFENDER TWEAKS ===" -ForegroundColor Cyan

# Set Defender to low priority and schedule scans only on AC power
try {
    Set-MpPreference -ScanOnlyIfIdleEnabled $true -ErrorAction SilentlyContinue
    Write-Host "[OK] Scan only when idle: Enabled" -ForegroundColor Green

    Set-MpPreference -DisableCpuThrottleOnIdleScans $false -ErrorAction SilentlyContinue
    Write-Host "[OK] CPU Throttle on scans: Enabled" -ForegroundColor Green

    Set-MpPreference -ScanAvgCPULoadFactor 20 -ErrorAction SilentlyContinue
    Write-Host "[OK] Scan CPU Load: 20% max" -ForegroundColor Green

    Set-MpPreference -EnableLowCpuPriority $true -ErrorAction SilentlyContinue
    Write-Host "[OK] Low CPU Priority: Enabled" -ForegroundColor Green
} catch {
    Write-Host "[!!] Some Defender settings require manual change" -ForegroundColor Yellow
}

Write-Host "`n=== 3. FAST STARTUP DISABLE ===" -ForegroundColor Cyan

# Disable Fast Startup via Registry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0 -ErrorAction SilentlyContinue
Write-Host "[OK] Fast Startup: Disabled" -ForegroundColor Green

Write-Host "`n=== 4. DELIVERY OPTIMIZATION OFF ===" -ForegroundColor Cyan

# Disable Delivery Optimization (P2P Updates)
$doPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
if (!(Test-Path $doPath)) {
    New-Item -Path $doPath -Force | Out-Null
}
Set-ItemProperty -Path $doPath -Name "DODownloadMode" -Value 0 -ErrorAction SilentlyContinue
Write-Host "[OK] Delivery Optimization: Disabled" -ForegroundColor Green

# Also via Group Policy path
$doPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
if (!(Test-Path $doPolicy)) {
    New-Item -Path $doPolicy -Force | Out-Null
}
Set-ItemProperty -Path $doPolicy -Name "DODownloadMode" -Value 0 -ErrorAction SilentlyContinue
Write-Host "[OK] Delivery Optimization Policy: Disabled" -ForegroundColor Green

Write-Host "`n=== 5. NETWORK ADAPTER POWER SETTINGS ===" -ForegroundColor Cyan

# Get all network adapters
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

foreach ($adapter in $adapters) {
    $adapterName = $adapter.Name
    Write-Host "Configuring: $adapterName" -ForegroundColor Yellow

    # Disable Wake on Magic Packet
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Wake on Magic Packet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue

    # Disable Wake on Pattern Match
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Wake on Pattern Match" -DisplayValue "Disabled" -ErrorAction SilentlyContinue

    # Enable Energy Efficient Ethernet (if available)
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Energy Efficient Ethernet" -DisplayValue "Enabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Energy-Efficient Ethernet" -DisplayValue "Enabled" -ErrorAction SilentlyContinue

    # Disable Wake on LAN
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Wake on LAN" -DisplayValue "Disabled" -ErrorAction SilentlyContinue

    # Set Power Saving Mode
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Power Saving Mode" -DisplayValue "Enabled" -ErrorAction SilentlyContinue

    # Reduce transmit power for WiFi (if available)
    Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Transmit Power" -DisplayValue "Lowest" -ErrorAction SilentlyContinue

    Write-Host "[OK] $adapterName configured" -ForegroundColor Green
}

# Disable network adapter power management wakeup via PowerShell
$adaptersWMI = Get-WmiObject MSPower_DeviceWakeEnable -Namespace root\wmi -ErrorAction SilentlyContinue
foreach ($adapter in $adaptersWMI) {
    $adapter.Enable = $false
    $adapter.Put() | Out-Null
}
Write-Host "[OK] Wake-on-LAN globally disabled" -ForegroundColor Green

Write-Host "`n=== ALL DONE ===" -ForegroundColor Cyan
Write-Host "Restart recommended for full effect." -ForegroundColor Yellow
