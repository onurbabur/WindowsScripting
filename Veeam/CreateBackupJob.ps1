#Backup365 Modülünü Import eder
Import-Module "C:\Program Files\Veeam\Backup365\Veeam.Archiver.PowerShell\Veeam.Archiver.PowerShell.psd1"

#Organizasyon bilgisi girilir
$org=Get-VBOOrganization -Name "xx.onmicrosoft.com"
#Yedegi Alınacak kullanıcıların listesi a.b@mail.com olacak şekilde txt den import edilir.
$usernames=Get-Content -Path C:\Temp\exportuser.txt

#kullanıcıların  organizasyon içerisindeki durumunu kontrol eder
$Users=Get-VBOOrganizationUser -Organization $org | ?{$usernames.Contains($_.UserName)}

#döngü içerisinde kullanıcıların export edilecek servislerini aktif eder. Mailbox ve arşiv backup için aktif ediyorum
foreach ($user in $users) {
$bi=New-VBOBackupItem -User $user -Mailbox:$True -ArchiveMailbox:$true -OneDrive:$false -Sites:$false

#her kullanıcı için ayrı ayrı job oluşturmasını sağlar
Add-VBOJob -Organization $org -Name $user -Repository (Get-VBORepository) -SelectedItems $bi

#oluşturulan jobu start eder
Get-VBOJob -Name $user | start-vbojob
}
