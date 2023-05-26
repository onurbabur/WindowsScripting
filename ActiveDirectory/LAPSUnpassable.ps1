$computers = (Get-ADComputer -SearchBase "OU=TURKEY-TR,OU=Accounts,DC=xxx,DC=xxx" -Properties * -filter *).name

  foreach ($comp in $computers) {

        Get-AdmPwdPassword -ComputerName $comp | where {$_.password -eq $null} | select computername, Distinguishedname

}
