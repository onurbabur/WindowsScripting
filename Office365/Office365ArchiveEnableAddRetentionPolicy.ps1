#arşiv özelliği kapalı olan kullanıcıları $users değişkenine atar
$users=(Get-ExoMailbox -ResultSize Unlimited -PropertySets Archive | where {$_.ArchiveStatus -eq "None"}).UserPrincipalName
$archiveenabled= "Mail Adresi"
$archiveenabled += "`r`n"
$count = 0

foreach($usr in $users) {

#users içerisinde olan kullanıcıları tek tek mailbox boyutları çevrilir.
    $Stats = Get-EXOMailbox -UserPrincipalName $usr | Get-EXOMailboxStatistics | Select-Object *, @{Name="TotalItemSizeGB"; Expression={[math]::Round(($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1GB),0)}}
    
#çevrilen boyutlar içerisinde +50GB boyutunu aşmiş kullanıcı var ise bu koşula uyuyorsa sırsaıyla
        if ($Stats.TotalItemSizeGB -gt 50) {
            #50GB aşan kullanıcının arşiv özelliği açılır.
            Enable-Mailbox -Identity $usr -Archive
            #Ortamımızda yazdıgımız custom retention policy uygulanır. (1yıldan önceki mailler arşive taşınacak)
            Set-Mailbox -Identity $usr -RetentionPolicy "1 Year Move to Archive RNS"
            #Arşivi açılan kullanıcının Arşiv özelliğini unlimited olarak çeviriyoruz.
            Enable-Mailbox $usr -AutoExpandingArchive
            #Arşiv politikasının direk devreye girmesi için tetikleme işlemi yapılır. Varsayılanda Microsoft bu işlemi 7 günde bir tetiklemektedir.
            Start-ManagedFolderAssistant $usr
            
            $archiveenabled += $usr
            $archiveenabled += "`r`n"
            $count++
        }
}
$dirarchiveenabled = "C:\Script\ArchiveEnabled\archiveenabled.txt"
$archiveenabled | Out-File $dirarchiveenabled

if($count -ne 0) {
#eğer işlem yapılan bir kullanıcı varsa o kullanıcının bilgilerini ilgili mail adreslerine bilgilendirme amaçlı mail atmakta.
    Send-MailMessage -To "o365<o365@babur.com>" -From "IT Department <onur.babur@babur.com>" -Subject "Office 365 Arşiv ve Retention Policy Uygulanan Kullanıcılar" -Body "Ekteki Kullanıcılar +50GB Mailbox kullanımına erişmiştir. Kullanıcıda Arşiv etkinleştirilmiş ve 1 yıldan eski mailleri arşive taşınması için aksiyon alınmıştır." -Attachments $dirarchiveenabled -SmtpServer "xxxxx" -Encoding utf8
}
