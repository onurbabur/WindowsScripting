$os= (Get-WmiObject -class Win32_OperatingSystem).Caption

 if ($os -eq "Microsoft Windows Server 2022 Standard") {

    $UpdatePath = "\\xxx.babur.hol\WUpdates\RNS-SUP-SRV-2022-09\2022"

    $Updates = Get-ChildItem -Path $UpdatePath | Where-Object {$_.Name -like "*.msu"}

        foreach ($update in $Updates) {

            $UpdateFilePath = $Update.FullName

            write-host "Güncelleştirme yükleniyor $update"

            Start-Process -Wait wusa -ArgumentList "/update $UpdateFilePath","/quiet","/norestart"
       
      }
 }
