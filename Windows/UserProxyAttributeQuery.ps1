# İlgili kullanıcı adını kontrol etmek için PowerShell komutu
$user = Get-ADUser -Filter { (UserPrincipalName -eq 'florya@xxx.com.tr') -or (ProxyAddresses -like 'florya@xxx.com.tr') }

if ($user -ne $null) {
    Write-Host "Kullanıcı bulundu: $($user.SamAccountName)"
} else {
    Write-Host "Kullanıcı bulunamadı."
}