$dosyaYolu = "D:\xxx.exe"
$hedefDizin = "c$\Windows\System32\"

# Not defteri içindeki IP adreslerini okuyarak ilerle
$ipListesi = Get-Content -Path "D:\ServerList\sysinternalupdate.txt"

#txt ile ugrasmak istemezseniz aşağıdaki gibi ufak bir array ile de herkese iletebiliriz.
#$ipListesi = @("10.0.0.1", "10.0.0.2", "10.0.0.3", "10.0.0.4", "10.0.0.5", "10.0.0.6", "10.0.0.7", "10.0.0.8", "10.0.0.9", "10.0.0.10")


foreach ($ip in $ipListesi) {
    $hedefPath = "\\$ip\$hedefDizin"
    Copy-Item -Path $dosyaYolu -Destination $hedefPath -Force
    Write-Host "Dosya, $ip adresine başarıyla kopyalandı."
}