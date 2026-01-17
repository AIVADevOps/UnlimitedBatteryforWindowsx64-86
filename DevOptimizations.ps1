# Dev Tools Optimization Script
# Run as Administrator
# Optimizes VS Code, Node.js, Antigravity for battery efficiency

Write-Host "=== Dev Tools Battery Optimization ===" -ForegroundColor Cyan

# 1. Import Registry (Process Priority)
Write-Host "`n[1/4] Setting Process Priorities (Registry)..." -ForegroundColor Yellow
$regFile = "$PSScriptRoot\2_Registry\DevToolsEfficiency.reg"
if (Test-Path $regFile) {
    Start-Process regedit -ArgumentList "/s `"$regFile`"" -Wait
    Write-Host "[OK] VS Code, Node.js, Antigravity: BelowNormal Priority" -ForegroundColor Green
} else {
    Write-Host "[SKIP] Registry file not found" -ForegroundColor Yellow
}

# 2. Windows Defender Exclusions (BIG performance impact for dev!)
Write-Host "`n[2/4] Adding Windows Defender Exclusions..." -ForegroundColor Yellow

$exclusions = @(
    "$env:USERPROFILE\node_modules",
    "$env:USERPROFILE\.npm",
    "$env:USERPROFILE\.vscode",
    "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Projects",
    "$env:USERPROFILE\dev",
    "C:\Program Files\nodejs"
)

foreach ($path in $exclusions) {
    if (Test-Path $path) {
        try {
            Add-MpPreference -ExclusionPath $path -ErrorAction SilentlyContinue
            Write-Host "[OK] Excluded: $path" -ForegroundColor Green
        } catch {
            Write-Host "[SKIP] $path" -ForegroundColor Gray
        }
    }
}

# Also exclude processes
$processes = @("node.exe", "Code.exe", "Antigravity.exe", "electron.exe", "npm.cmd", "npx.cmd")
foreach ($proc in $processes) {
    try {
        Add-MpPreference -ExclusionProcess $proc -ErrorAction SilentlyContinue
        Write-Host "[OK] Process excluded: $proc" -ForegroundColor Green
    } catch {
        Write-Host "[SKIP] $proc" -ForegroundColor Gray
    }
}

# 3. Node.js Environment Variables for efficiency
Write-Host "`n[3/4] Setting Node.js Environment Variables..." -ForegroundColor Yellow

# Reduce V8 memory usage
[Environment]::SetEnvironmentVariable("NODE_OPTIONS", "--max-old-space-size=512", "User")
Write-Host "[OK] NODE_OPTIONS: --max-old-space-size=512 (limits memory)" -ForegroundColor Green

# 4. VS Code recommendations
Write-Host "`n[4/4] VS Code Settings Recommendations..." -ForegroundColor Yellow
Write-Host @"

Add these to VS Code settings.json for better battery life:

{
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.git/**": true,
    "**/dist/**": true,
    "**/build/**": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true
  },
  "typescript.tsserver.maxTsServerMemory": 512,
  "extensions.autoUpdate": false,
  "telemetry.telemetryLevel": "off",
  "update.mode": "manual"
}

"@ -ForegroundColor White

Write-Host "`n=== DONE ===" -ForegroundColor Cyan
Write-Host "Restart apps for changes to take effect." -ForegroundColor Yellow
