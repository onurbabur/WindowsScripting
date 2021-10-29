$objects = Get-ADUser -Filter * -SearchBase "OU=TURKEY-TR,OU=Accounts,DC=ronesans,DC=hol" -Properties  samaccountname, pwdLastSet
foreach ($object in $objects) {
  if (($object.samaccountname -like '*ö*') -or ($object.samaccountname -like '*ı*') -or ($object.samaccountname -like '*ğ*')  ) {
    Write-Host "Name contains '$'"
    $object.samaccountname
    } 
 } 
