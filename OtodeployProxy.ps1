#Proxy addresi boş olan kullanıcılara oto olarak proxy address ataması yapmaktadır
#Office 365 geçişi ve benzeri durumlarda ihtiyacımız olan ilgili verilerin attribute içerisine tanımlanmasi
#


#işlemin hangi dc üzerinde gerçekleştirileceğini belirtiyoruz
$dc="dc01"
#ad modülü import edilir
Import-Module activedirectory

#eklenmesini istedigimiz domain bilgilerini yazalim
$newproxy = "@babur.com"
$newproxy2 = "@babur.onmicrosoft.com"
$newproxy3 = "@babur.mail.onmicrosoft.com"

#kullanıcıların bulundugu OU belirtilir
$userou = "OU=TURKEY-TR,OU=Accounts,DC=babur,DC=hol"

#proxyaddresses attribute alanı boş olan kullanıcıları users degişlenine atarız
$users = Get-ADUser -SearchBase $userou  -filter "proxyaddresses -notlike '*'" -Properties mail, ProxyAddresses

Foreach ($user in $users) {

#kullanıcının mail attribute alanında yazan mail adresinden domain bilgisi silinerek yeni domain bilgisi ilgili değişkende birleştirilip Proxyaddress attribute içerisine yazılır.
Set-ADUser -server $dc -Identity $user.SamAccountName -Add @{Proxyaddresses=”smtp:”+$user.mail.TrimEnd("babur.com").TrimEnd("@")+””+$newproxy}
Set-ADUser -server $dc -Identity $user.SamAccountName -Add @{Proxyaddresses=”smtp:”+$user.mail.TrimEnd("babur.com").TrimEnd("@")+””+$newproxy2}
Set-ADUser -server $dc -Identity $user.SamAccountName -Add @{Proxyaddresses=”smtp:”+$user.mail.TrimEnd("babur.com").TrimEnd("@")+””+$newproxy3}

}

