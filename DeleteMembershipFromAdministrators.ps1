$administrators = @(
([ADSI]"WinNT://./Administrators").psbase.Invoke('Members') |
% { 
 $_.GetType().InvokeMember('AdsPath','GetProperty',$null,$($_),$null) 
}
) -match '^WinNT';
$administrators = $administrators -replace "WinNT://",""
foreach ($adm in $administrators) {
    if($adm -match 'S-1-5-21*') {
        Remove-LocalGroupMember -Group "Administrators" -Member $adm
    }
}
