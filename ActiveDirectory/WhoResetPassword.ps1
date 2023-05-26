$servers= "RNS-DC06"

$servers | foreach {
    Get-WinEvent -ComputerName $_ -FilterHashtable @{LogName=”Security”;ID=4723 }| Foreach {
        $event = [xml]$_.ToXml()
        if($event)
        {
            $Time = Get-Date $_.TimeCreated -UFormat “%Y-%d-%m %H:%M:%S”
            $AdmUser = $event.Event.EventData.Data[4].”#text”
            $User = $event.Event.EventData.Data[0].”#text”
            $dc = $event.Event.System.computer
            write-host “Admin ” $AdmUser “ isimli yetkili, ” $User “  parolasını bu ” $dc “ de yeniledi.“ $Time
        }
    }
}

