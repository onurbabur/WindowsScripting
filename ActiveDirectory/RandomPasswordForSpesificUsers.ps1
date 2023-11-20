Function Get-RandomPassword
{
    #define parameters
    param([int]$PasswordLength = 10)
 
    #ASCII Character set for Password
    $CharacterSet = @{
            Uppercase   = (97..122) | Get-Random -Count 10 | % {[char]$_}
            Lowercase   = (65..90)  | Get-Random -Count 10 | % {[char]$_}
            Numeric     = (48..57)  | Get-Random -Count 10 | % {[char]$_}
            SpecialChar = (33..47)+(58..64)+(91..96)+(123..126) | Get-Random -Count 10 | % {[char]$_}
    }
 
    #Frame Random Password from given character set
    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    -join(Get-Random -Count $PasswordLength -InputObject $StringSet)
}
 
#Call the function to generate random password of 8 characters
Get-RandomPassword -PasswordLength 8
 
#Sample Output: glx`FC>Y

# Organizasyon Birimi (OU) adı
$users = Import-CSV -Path C:\Windows\Temp\usr.txt -Header Users

# OU içindeki kullanıcıları al
#$users = Get-ADUser -Filter * -SearchBase $ouName

foreach ($user in $users) {
    # Kullanıcı adını al
    $username = $user.Users
   
    # Yeni parolayı oluştur
    $newPassword = Get-RandomPassword -PasswordLength 16

    # Parolayı sıfırla
    Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force)

    # Kullanıcıya bilgi mesajını yazdır
    write-Host "Kullanıcı: $username için yeni parola: $newPassword"
}