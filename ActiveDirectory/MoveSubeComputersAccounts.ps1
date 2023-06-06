# Gerekli parametreleri ayarlayın
$sourceOU = "CN=Computers,DC=babur,DC=com,DC=tr"
$destinationOU = "OU=Store-Computer-Objects,OU=Stores-DP,OU=005-Stores,DC=babur,DC=com,DC=tr"
$usernamePrefixes = @("PULSE", "VM")
$suffix = "GPS"
$senderEmailAddress = "infra@babur.com.tr"
$smtpServer = "10.x.x.x"
$smtpPort = 25

# Active Directory modülünü içe aktar
Import-Module ActiveDirectory
$willmove = $null
$willmove=@()

# Taşınacak hesapları alın
$accountsToMove = Get-ADComputer -SearchBase $sourceOU -Filter * | Where-Object {
    $computerName = $_.Name
    $prefixFound = $false
    $suffixFound = $false


    foreach ($prefix in $usernamePrefixes) {
        if ($computerName -like "$prefix*") {
             $willmove += $computerName
            $prefixFound = $true
            break
           
        }
    }


    if ($computerName -like "*$suffix") {
        $willmove += $computerName
        $suffixFound = $true
    }

    $suffixFound

}

# E-posta gönderme işlemi
$mailBody = "Asagidaki hesaplar belirtilen OU'ya tasindi:`n`n"
$mailBody += $willmove

$mailParams = @{
    SmtpServer = $smtpServer
    Port = $smtpPort
    UseSsl = $false
    From = "infra@babur.com.tr"
    To = "infra-alert@babur.com.tr"
    Subject = "Hesap Tasima Bildirimi"
    Body = $mailBody
}

# Hesapları belirtilen OU'ya taşıyın
foreach ($account in $willmove) {
    Get-ADComputer $account | Move-ADObject -TargetPath $destinationOU
    
}

if ($willmove -ne $null)  {

    write-host "tasinacak hesap var"
    Send-MailMessage @mailParams

}

else {
    
    write-host "tasinacak hesap yok"

}

