param([int]$Port = 5000)
$proc = $null
try {
    Write-Host "Starting ASP.NET API..."
    $proc = Start-Process -FilePath "dotnet" -ArgumentList "run --no-build --urls http://localhost:$Port" -PassThru -NoNewWindow
    Start-Sleep -Seconds 8
    
    Write-Host "Testing endpoint..."
    $response = Invoke-WebRequest -Uri "http://localhost:$Port/weatherforecast" -TimeoutSec 5
    Write-Host "Status: $($response.StatusCode)"
    Write-Host "Content received: $($response.Content.Length) bytes"
    $json = $response.Content | ConvertFrom-Json
    Write-Host "Sample record: $(($json[0] | ConvertTo-Json -Compress))"
    Write-Host "SUCCESS: API is working"
    exit 0
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
    exit 1
} finally {
    if ($proc) {
        try { Stop-Process -Id $proc.Id -Force } catch {}
    }
}
