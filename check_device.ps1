# Device Connection Monitor
Write-Host "Monitoring for Android device connection..." -ForegroundColor Green
Write-Host "Connect your device now..." -ForegroundColor Yellow
Write-Host ""

while ($true) {
    $devices = adb devices
    Clear-Host
    Write-Host "=== Android Device Monitor ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host $devices
    Write-Host ""
    Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Gray
    Start-Sleep -Seconds 2
}

