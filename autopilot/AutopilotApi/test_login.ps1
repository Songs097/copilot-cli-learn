$proc = Start-Process -FilePath "dotnet" -ArgumentList "run --no-build --urls http://localhost:5000" -PassThru -NoNewWindow
Start-Sleep -Seconds 8

try {
    # Test login endpoint
    $loginPayload = @{
        username = "demo"
        password = "demo123"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:5000/auth/login" -Method Post -Body $loginPayload -ContentType "application/json" -UseBasicParsing -TimeoutSec 5
    
    $result = $response.Content | ConvertFrom-Json
    
    Write-Host "✅ Login API Test Results:"
    Write-Host "  Status Code: $($response.StatusCode)"
    Write-Host "  Success: $($result.Success)"
    Write-Host "  Message: $($result.Message)"
    Write-Host "  User: $($result.User.Username) ($($result.User.Email))"
    Write-Host "  Token Length: $($result.Token.Length) characters"
    Write-Host "  Expires At: $($result.ExpiresAt)"
    
    exit 0
} catch {
    Write-Host "❌ Test failed: $($_.Exception.Message)"
    exit 1
} finally {
    if ($proc) { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue }
}
