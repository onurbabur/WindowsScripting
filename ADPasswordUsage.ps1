$users = (Get-ADUser -Properties * -filter * -SearchBase "OU=Accounts,DC=babur,DC=hol" | select samaccountname).SamAccountName
    foreach ($username in $users) {
        $user = Get-ADUser -identity $username -properties pwdlastset
            #Değişmeden önceki tarih
            [datetime]::FromFileTime($user.pwdlastset)
            $user.pwdlastset=0
            set-aduser -Instance $user
            $user.pwdlastset = -1
            set-aduser -Instance $user
            $user = Get-ADUser -identity $username -properties pwdlastset
            #Değiştikten sonraki tarih
            [datetime]::FromFileTime($user.pwdlastset)
}
