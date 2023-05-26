$str="Name;Memberof"
$str+= "`r`n" 
$list = get-aduser -filter * -SearchBase "OU=TR,DC=babur,DC=hol" | select samaccountname
$list.samaccountname| `
  %{  
        $user = $_; 
        
        $grp=((get-aduser $user -Properties memberof | select memberof).memberof |  Get-ADGroup|select Name|sort name).name 
        foreach ($g in $grp) {
            $str+=$user+";"+$g
            $str += "`r`n" 
             
        } 
    }
$str | Out-File C:\Temp\memberof.csv -Encoding utf8 
