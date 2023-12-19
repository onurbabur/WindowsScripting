# Triple DES 168 şifreleme algoritmasını devre dışı bırakma

# Kayıt defteri anahtarları
$registryKey1 = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
$registryKey2 = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168\168"

# Triple DES 168 şifrelemesinin etkin olup olmadığını kontrol et
$isEnabled = (Get-ItemProperty -Path $registryKey1 -Name "Enabled" -ErrorAction SilentlyContinue).Enabled

# Eğer Triple DES 168 etkinse, devre dışı bırak
if ($isEnabled -eq 0) {
    Write-Host "Triple DES 168 zaten devre dışı bırakılmış."
} else {
    # Anahtarları oluştur veya güncelle
    New-Item -Path $registryKey1 -Force
    New-Item -Path $registryKey2 -Force

    # Triple DES 168 şifrelemeyi devre dışı bırak
    New-ItemProperty -Path $registryKey1 -Name "Enabled" -Value 0 -PropertyType DWORD -Force
    New-ItemProperty -Path $registryKey2 -Name "Enabled" -Value 0 -PropertyType DWORD -Force

    Write-Host "Triple DES 168 şifreleme başarıyla devre dışı bırakıldı."
}