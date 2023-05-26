
$count = 0
#$str="IP, Sunucu Adı,Disk Adı,Disk,Boyut,Boş,Yüzde "
#$str+= "`r`n"
$diskstates = "<!DOCTYPE html> `
<html> `
<head> `
<style> `
table { `
    font-family: arial, sans-serif; `
    border-collapse: collapse; `
    width: 80%; `
} `

td, th { `
    border: 1px solid #dddddd; `
    text-align: left; `
    padding: 8px; `
} `

tr:nth-child(even) { `
    background-color: #dddddd; `
} `
</style> `
</head> `
<body> `

<table> ` 
<tr> `
    <th width='15%'>Server Name</th> `
    <th width='25%'>IP Adres</th> `
    <th width='20%'>Disk ID</th> `
    <th width='20%'>Disk Alanı</th> `
    <th width='20%'>Boş Alan (GB)</th> `
    <th width='20%'>Kullanılan (%)</th> `
  </tr> "


Get-ADComputer -filter  {enabled -eq "true"} -SearchScope Subtree -SearchBase "OU=Servers,DC=babur,DC=hol" | ForEach-Object {

    $srvname = $_.name
    $ipadd = (resolve-dnsname $srvname).IPAddress
    
    Get-WmiObject Win32_LogicalDisk -ComputerName $srvname -Filter "DriveType='3'" | ForEach-Object { 

        
        $disksize = [math]::round($_.size /1Gb, 2)
        $freespace = [math]::round($_.freespace /1Gb, 2)
        $usagespace = $disksize - $freespace
        $usagerate = ($usagespace/$disksize)*100
        $usagerate = [math]::round($usagerate, 2)
        $diskid = $_.deviceid


        if ($usagerate -ge 90) {
                
         $diskstates += "<tr> `
        <th width='15%' bgcolor='red'> $srvname </th> `
        <th width='25%' bgcolor='red'> $ipadd </th> `
        <th width='20%' bgcolor='red'> $diskid </th> `
        <th width='20%' bgcolor='red'> $disksize </th> `
        <th width='20%' bgcolor='red'> $freespace </th> `
        <th width='20%' bgcolor='red'> $usagerate </th> "

        $diskstates += "</tr> "
    
        }            

    }
    
        
}



Get-ADComputer -filter  {enabled -eq "true"} -SearchScope Subtree -SearchBase "OU=Domain Controllers,DC=babur,DC=hol" | ForEach-Object {

    $srvname = $_.name
    $ipadd = (resolve-dnsname $srvname).IPAddress
    
    Get-WmiObject Win32_LogicalDisk -ComputerName $srvname -Filter "DriveType='3'" | ForEach-Object { 

        
        $disksize = [math]::round($_.size /1Gb, 2)
        $freespace = [math]::round($_.freespace /1Gb, 2)
        $usagespace = $disksize - $freespace
        $usagerate = ($usagespace/$disksize)*100
        $usagerate = [math]::round($usagerate, 2)
        $diskid = $_.deviceid


        if ($usagerate -ge 90) {
                
         $diskstates += "<tr> `
        <th width='15%' bgcolor='red'> $srvname </th> `
        <th width='25%' bgcolor='red'> $ipadd </th> `
        <th width='20%' bgcolor='red'> $diskid </th> `
        <th width='20%' bgcolor='red'> $disksize </th> `
        <th width='20%' bgcolor='red'> $freespace </th> `
        <th width='20%' bgcolor='red'> $usagerate </th> "

        $diskstates += "</tr> "
    
        }            

    }
    
        
}



$diskstates += "</table> `

</body> `
</html> "

#$diskstates | Out-File D:\test.html

Send-MailMessage -From "MSY Reports <it@rbabur.com>" -To "IT MSY <hld-it-msy@babur.com>" `
                        -Subject "Sunucu Doluluk Oranları" -Body $diskstates -BodyAsHtml `
                       -SmtpServer 172.22.22.22 -Port 25 -Encoding UTF8
