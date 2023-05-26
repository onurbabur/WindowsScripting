# Start HTML Output file style
$style = "<style>"
$style = $style + "Body{background-color:white;font-family:Arial;font-size:10pt;}"
$style = $style + "Table{border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}"
$style = $style + "TH{border-width: 1px; padding: 2px; border-style: solid; border-color: black; background-color: #cccccc;}"
$style = $style + "TD{border-width: 1px; padding: 5px; border-style: solid; border-color: black; background-color: white;}"
$style = $style + "</style>"
# End HTML Output file style

$array=@()
$count=0
[System.Collections.ArrayList]$array2=@()


Connect-VIServer -server vcenteriporfqdn -user administrator@vsphere.local -pass parola bilgisi #vcenter bağlantısı
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false #vcenter ssl hatasinin görmezden gelinmesi
$vmos=(Get-VM).Name #vcenter üzerinde çalışan sanal makine bilgileri


Connect-VBRServer -Server localhost
$policys =(Get-VBRJob | select Name).name

 
foreach ($backup in $policys) { 
    $array += ($backup | Get-VBRJobObject).name
}   #jobların içerisinde bulunan sanal makinelerin $array değişkeni içerisine tek tek kayıt edilmesi
 
Disconnect-VBRServer # veeam üzerinden disconnect olunması

foreach ($temp in $vmos) {

    if(!($array.Contains($temp))) { 
        
        $count++ # eşleşmiyorsa +1 count değerinin artırılması
        $array2 += $temp #eşleşmeyen makine isminin $array3e eklenmesi
     }


}

$dontshow= Import-Csv C:\Scripts\nobackupinfo.txt -Header DontShow

 foreach($temp in $dontshow) {  #zerto.csv icerisinde belirtilen makineleri array2 icerisine ekleyerek farklarin kontrol edilgidi fonksiyon icerisine bu makineler veeam uzerindeymis gibi gosterir

    $array2.Remove($temp.DontShow)

}


$array2 | Out-File C:\Scripts\thereisnovmbackup.csv
$nobackup = Import-Csv "C:\Scripts\thereisnovmbackup.csv" -Header Name
$nobackup  | ConvertTo-Html -Head $style  Name | Out-File C:\Scripts\Ahey.html

Send-MailMessage -From "Veeam <ankveeam@xx.com>" -To "Onur Babur <onur.babur@xx.com>" -Subject "No Backup Systems" -SmtpServer xx -Port 25 -Body (Get-Content C:\Scripts\Ahey.html | Out-String) -BodyAsHtml
