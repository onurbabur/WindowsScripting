Import-Module Veeam.Archiver.PowerShell
Import-Module Veeam.Exchange.PowerShell

$organization = Get-VBOOrganization -Name "xxx.onmicrosoft.com"
Start-VBOExchangeItemRestoreSession -LatestState -Organization $organization
$session = Get-VBOExchangeItemRestoreSession
$database = Get-VEXDatabase -Session $session

$mailboxes = Get-VEXMailbox -Database $database

foreach ($user in $mailboxes)
{
    $mailbox = Get-VEXMailbox -Database $database -name $user
    Export-VEXItem -Mailbox $mailbox -To "G:\My Drive\Office365\$($user.Email).pst"
}
