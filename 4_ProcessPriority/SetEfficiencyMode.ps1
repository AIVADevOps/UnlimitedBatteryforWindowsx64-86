# Set Efficiency Mode (Low Priority) for specified apps
# Note: This only lasts until process restart - use Process Lasso for permanent rules

$apps = @("Discord", "chrome", "Spotify", "Code", "Antigravity")

foreach ($appName in $apps) {
    $processes = Get-Process -Name $appName -ErrorAction SilentlyContinue
    if ($processes) {
        foreach ($proc in $processes) {
            try {
                $proc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal
                Write-Host "Set $($proc.ProcessName) (PID: $($proc.Id)) to BelowNormal priority" -ForegroundColor Green
            } catch {
                Write-Host "Could not set priority for $($proc.ProcessName) (PID: $($proc.Id)): $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "$appName is not running" -ForegroundColor Gray
    }
}

Write-Host "`nDone! Note: These settings reset when apps restart." -ForegroundColor Cyan
Write-Host "For PERMANENT rules, install Process Lasso." -ForegroundColor Cyan
