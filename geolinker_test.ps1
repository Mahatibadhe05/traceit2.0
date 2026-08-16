$apiKey = Read-Host "Enter your GeoLinker API key"

$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type"  = "application/json"
}

$body = @{
    device_id = "TRACEIT_TEST_001"
    timestamp = @((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss"))
    lat       = @(19.0760)
    long      = @(72.8777)
    battery   = @(82)
} | ConvertTo-Json -Compress

Write-Host "Sending test location to GeoLinker..."

try {
    $response = Invoke-RestMethod `
        -Uri "https://www.circuitdigest.cloud/api/v1/geolinker" `
        -Method Post `
        -Headers $headers `
        -Body $body

    Write-Host "GeoLinker response:"
    $response | ConvertTo-Json -Depth 10
}
catch {
    Write-Host "GeoLinker request failed:"
    Write-Host $_
}