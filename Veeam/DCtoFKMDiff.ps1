# Start HTML Output file style
$style = "<style>"
$style = $style + "Body{background-color:white;font-family:Arial;font-size:10pt;}"
$style = $style + "Table{border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}"
$style = $style + "TH{border-width: 1px; padding: 2px; border-style: solid; border-color: black; background-color: #cccccc;}"
$style = $style + "TD{border-width: 1px; padding: 5px; border-style: solid; border-color: black; background-color: white;}"
$style = $style + "</style>"
# End HTML Output file style


$array=@()
$array2=@()
$count=0
$array3=@()
$array3=$null
$str+= "`r`n"

Import-Module Veeam.Backup.PowerShell #veeam eklentinin aktifleştirilmesi
Connect-VBRServer -Server 172.22.8.64 #ankara veeam login olunması
$ankara =(Get-VBRJob | select Name).name # ankara veeam üzerinde bulunan Jobların $ankara değişkenine atanması
 
foreach ($backup in $ankara) { 
    $array += ($backup | Get-VBRJobObject).name
}   #jobların içerisinde bulunan sanal makinelerin $array değişkeni içerisine tek tek kayıt edilmesi
 
Disconnect-VBRServer # ankara veeam üzerinden disconnect olunması
 
Connect-VBRServer -Server xxx  #fkm veeam login olunması
 
$istanbul =(Get-VBRJob | select Name).name # istanbul veeam üzerinde bulunan jobların $istanbul değişkenine atanması

foreach ($backup2 in $istanbul) {

    $array2 += ($backup2 | Get-VBRJobObject).name
   
}    #jobların içerisinde bulunan sanal makinelerin $array2 değişkeni içerisine tek tek kayıt edilmesi

$zerto = Import-Csv C:\Scripts\zerto.txt -Header Zerto
 
 foreach($temp in $zerto) {  #zerto.csv icerisinde belirtilen makineleri array2 icerisine ekleyerek farklarin kontrol edilgidi fonksiyon icerisine bu makineler veeam uzerindeymis gibi gosterir

    $array2 += $temp.Zerto
}


Disconnect-VBRServer #fkm veeam üzerinden disconnect olunması
 
foreach ($temp in $array) {     #ankara veeam üzerinde tanımlı OS lerin temp içerisine tek tek alınması
    if(!($array2.Contains($temp))) {   # istanbul veeam üzerinde bulunan makinelerin temp içerisine atanan OS ismi ile eşlenip eşlenmediğinin tespiti, eşleşmiyorsa $array3 değerinin içerisine eşleşmeyen makine isminin eklenmesi
        $count++ # eşleşmiyorsa +1 count değerinin artırılması
        $array3 += $temp #eşleşmeyen makine isminin $array3e eklenmesi
        $array3 += "`r`n" # eklenme sonrası bir satır sonraya geçilmesi
   }
}

#$array3 | Out-File C:\Temp\fark.csv
$array3 | Out-File C:\Scripts\diffbackup.csv
$diffbackup = Import-Csv "C:\Scripts\diffbackup.csv" -Header Name
$diffbackup  | ConvertTo-Html -Head $style  Name | Out-File C:\Scripts\diffbackup.html


Send-MailMessage -From "Veeam <ankveeam@xx.com>" -To "Onur Babur <onur.babur@xx.com>"" -Subject "FKM'ye iletilmeyen Sistemler" -SmtpServer 172.22.xx.xx -Port 25 -Body (Get-Content C:\Scripts\diffbackup.html | Out-String) -BodyAsHtml
