$smtpServer = "10.x.x.x"
$smtpPort = 25
$sender = "xxx@onurbabur.com"
$recipient = "infra-alert@onurbabur.com"
$subject = "Failover Cluster Alert"

$startTime = (Get-Date).AddMinutes(-10)
$endTime = Get-Date
$eventID = 1641
$logName = 'Application'

$events = Get-winEvent -filterHashTable @{logname ='Microsoft-Windows-FailoverClustering/Operational'; id=$eventID; StartTime=$startTime; EndTime=$endTime}| ft -AutoSize -Wrap

if ($events) {
    $body = $events | Out-String

    $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $mailMessage = New-Object System.Net.Mail.MailMessage($sender, $recipient, $subject, $body)

    try {
        $smtp.Send($mailMessage)
        Write-Host "E-posta gönderildi!"
    } catch {
        Write-Host "E-posta gönderirken hata oluştu: $_.Exception.Message"
    }
} else {
    Write-Host "Belirtilen filtrelerle uyumlu olay bulunamadığından e-posta gönderilmedi."
}
