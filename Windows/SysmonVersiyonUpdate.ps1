# Txt dosyasının adı
$txtDosya = Import-Csv "\\xxx\SYSVOL\xxx\softwaresetup\Sysmon\sysmonupdate.txt" -Header ServerName

# Hostname'i al
$hostname = $env:COMPUTERNAME

# Sysmon versiyonunu al
$sysmonVersion = (Get-Command -Name sysmon).FileVersionInfo.ProductVersion

# Txt dosyasındaki her bir satırı kontrol et
try {
    foreach ($satir in $txtDosya.ServerName) {
        # Satır ile hostname'i karşılaştır
        if ($satir -eq $hostname) {
            # Eşleşme bulundu, scripti çalıştır
            Write-Host "Eşleşme bulundu! Sysmon güncelleniyor..."

            # Eğer sysmon versiyonu 15.11 değilse güncelle
            if ($sysmonVersion -ne "15.11") {
                Write-Host "Sysmon versiyonu $sysmonVersion. Güncelleniyor..."
                
                # Eski Sysmon sürümünü kaldır
                & sysmon -u
                & sysmon64 -u
                
                # Yeni Sysmon sürümünü yükle
                & "\\xxx\SYSVOL\xxx\softwaresetup\Sysmon\Sysmon.exe" -i -accepteula
                
                Write-Host "Sysmon güncellendi."
            } else {
                Write-Host "Sysmon zaten en son sürümde ($sysmonVersion). Güncelleme gerekmiyor."
            }

            # Buraya başka işlemleri ekleyebilirsiniz
            break
        }
    }
} catch {
    Write-Host "Hata: $_"
}
