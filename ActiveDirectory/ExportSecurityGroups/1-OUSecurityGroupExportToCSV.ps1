# İçe aktarım modülü
Import-Module ActiveDirectory

# İlgili OU'daki güvenlik gruplarını al
$ouDN = "OU=BI Users,DC=babur,DC=com,DC=tr"  # İlgili OU'nun DistinguishedName (DN) bilgisini girin
$groups = Get-ADGroup -Filter * -SearchBase $ouDN

# Her bir güvenlik grubu için CSV dosyasını oluşturma
foreach ($group in $groups) {
    $groupName = $group.Name
    $groupMembers = Get-ADGroupMember -Identity $group.DistinguishedName -Recursive | Where-Object { $_.objectClass -eq "user" }
    
    # Grup üyelerini içeren bir özel nesne oluşturma
    $membersObject = foreach ($member in $groupMembers) {
        $user = Get-ADUser -Identity $member.DistinguishedName -Properties samaccountname, mail
        [PSCustomObject]@{
            SamAccountName = $user.samaccountname
            Email = $user.mail
        }
    }
    
    # CSV dosyasını oluşturma ve verileri içeri aktarma
    $csvPath = "C:\Users\adm-obabur\Desktop\BIReports\$groupName.csv"  # CSV dosyasının kaydedileceği konumu ve dosya adını belirtin
    $membersObject | Export-Csv -Path $csvPath -NoTypeInformation
}

Write-Host "Tüm güvenlik grupları CSV dosyaları olarak dışa aktarıldı."
