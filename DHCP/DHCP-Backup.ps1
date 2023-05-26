$Computer = Get-ADObject -SearchBase "CN=NetServices,CN=Services,CN=Configuration,DC=xx,DC=xx,DC=xxr" -Filter * | Where {$.Name -notlike "DhcpRoot" -and $.Name -notlike "NetServices"}
$ComputerExport = $Computer.Name | Out-File D:\DHCP-Backup\DHCP-SERVER.txt

$ComputerName = Import-Csv D:\DHCP-Backup\DHCP-SERVER.txt -Header DHCPSERVERS

$date = Get-Date
$date = $date.ToString("yyyy-MM-dd")
$file = New-Item -Path "D:\DHCP-Backup\" -Name $date -ItemType "directory" -Force

foreach($temp in $ComputerName){

$name = $temp.DHCPSERVERS

Try {
    Export-DhcpServer -File "$File\$name.xml" -ComputerName $temp.DHCPSERVERS -Force -ErrorAction Ignore # -Ignore hata alan mevcut log dosyasının üzerine yazar.
  }
Catch {
    $_.Exception | Out-File $file\DHCP-LogError.txt -Append  # -Append mevcut log dosyasının üzerine yazar.
  }
}
Get-ChildItem $file > $file\DHCP-Log.txt

Send-MailMessage -To sistemyonetimi@dominospizza.com.tr -From "Infra No-Reply <infra-noreply@onurbabur.com>" -Subject "DHCP Backup" -Attachments $file\DHCP-Log.txt -Body "
` Ekteki sunucuların DHCP Yedekleri alınmıştır. Lütfen Hata alan sunucuları kontrol edin, kullanılmıyor ise DHCP üzerinden Unauthorize edin. `
           " -SmtpServer "10.147.x.xx" -Encoding UTF8
