$proc = Start-Process -FilePath "dotnet" -ArgumentList "run --no-build --urls http://localhost:5000" -PassThru -NoNewWindow
Start-Sleep -Seconds 8

try {
    # Test failed login
    $loginPayload = @{
        username = "demo"
        password = "wrongpassword"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:5000/auth/login" -Method Post -Body $loginPayload -ContentType "application/json" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
    
    if ($response.StatusCode -eq 401 -or $response.Content -like "*401*") {
        Write-Host "✅ Wrong password returns 401 Unauthorized"
    } else {
        Write-Host "Response: $($response.StatusCode)"
    }
    
    # Test another user
    $loginPayload = @{
        username = "admin"
        password = "admin123"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:5000/auth/login" -Method Post -Body $loginPayload -ContentType "application/json" -UseBasicParsing -TimeoutSec 5
    
    $result = $response.Content | ConvertFrom-Json
    Write-Host "✅ Admin login successful: $($result.User.Username)"
    
    exit 0
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
} finally {
    if ($proc) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue }
}
