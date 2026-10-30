$headers = @{ "x-admin-secret" = "thanhphat_admin_secret_key_2026_moneypod_admin" }
$body = '{"enable": false}'
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/admin/maintenance" -Method POST -Headers $headers -ContentType "application/json" -Body $body
Write-Host $response.message
