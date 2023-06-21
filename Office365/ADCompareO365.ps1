Connect-ExchangeOnline
$mailboxes = Get-Mailbox -ResultSize Unlimited | Select-Object UserPrincipalName
$userPrincipalNames = $mailboxes | Foreach-Object { $_.UserPrincipalName }


$users = Get-ADUser -Filter * -Properties mail
$mailArray = $users | Where-Object { $_.mail -ne $null } | Select-Object -ExpandProperty mail


#$usersWithMissingEmail = Compare-Object $mailArray $userPrincipalNames | Where-Object { $_.SideIndicator -eq '=>' } | Select-Object -ExpandProperty InputObject

#foreach ($user in $usersWithMissingEmail) {
#    Write-Host "Kullanıcı e-posta adresi eksik: $user"
#}


$usersWithMissingEmail = Compare-Object $mailArray $userPrincipalNames | Where-Object { $_.SideIndicator -eq '=>' } | Select-Object -ExpandProperty InputObject

# E-posta konusu
$subject = "Eksik E-posta Adresleri Raporu"

# E-posta body içerigi
$body = @"
<html>
<head>
    <style>
        table {
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Eksik E-posta Adresleri Raporu</h2>
    <p>Bu hesaplar AD'de yok, fakat Office 365 üzerinde yer almaktadır:</p>
    <table>
        <tr>
            <th>Kullanıcı Adı</th>
        </tr>
"@

# Eksik e-posta adreslerini ekleme
foreach ($user in $usersWithMissingEmail) {
    $body += "<tr><td>$user</td></tr>"
}

# Gövdeyi tamamla
$body += @"
    </table>
</body>
</html>
"@

# E-posta gönderme işlemi
$smtpServer = "10.147.x.x"
$smtpPort = 25
$sender = "no-reply@xxx.com.tr"
 $recipient = "onur.babur@dxxx.com.tr"

Send-MailMessage -From $sender -To $recipient -Subject $subject -BodyAsHtml $body -SmtpServer $smtpServer -Port $smtpPort