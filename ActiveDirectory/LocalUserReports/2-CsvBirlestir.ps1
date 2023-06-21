$klasorYolu = "\\dpprxxx01\OBTEST\Accounts"
$ciktiDosyasi = "\\dpprxxx01\OBTEST\Accounts\Tum_Kullanicilar.csv"

# CSV dosyalarının tam yolunu al
$csvDosyalari = Get-ChildItem -Path $klasorYolu -Filter "*.csv" | Select-Object -ExpandProperty FullName

# Boş bir CSV dosyası oluştur
$csvIcerik = @()
a
# Her CSV dosyasını oku ve içeriği birleştir
foreach ($csvDosyasi in $csvDosyalari) {
    $csvIcerik += Get-Content -Path $csvDosyasi
}

# Tüm içeriği çıktı dosyasına yaz
$csvIcerik | Out-File -FilePath $ciktiDosyasi -Encoding UTF8

Write-Host "Tüm kullanıcılar başarıyla birleştirildi: $ciktiDosyasi"