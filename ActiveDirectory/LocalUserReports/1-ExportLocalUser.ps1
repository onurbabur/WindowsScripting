$csvDosyasi = "\\dpprxxx01\OBTEST\Accounts\$env:COMPUTERNAME.csv"

$makineAdi = $env:COMPUTERNAME
$kullaniciListesi = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True"

$kullaniciSatirlari = @()

foreach ($kullanici in $kullaniciListesi) {
    $kullaniciAdi = $kullanici.Name
    $durum = if ($kullanici.Disabled) { "Disable" } else { "Enable" }
    $kullaniciSatir = "$makineAdi,$kullaniciAdi,$durum"
    $kullaniciSatirlari += $kullaniciSatir
}

$kullaniciSatirlari | Out-File -FilePath $csvDosyasi -Encoding UTF8

Write-Host "Kullanıcı listesi başarıyla kaydedildi: $csvDosyasi"