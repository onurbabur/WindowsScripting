Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -SearchScope Subtree -SearchBase "OU=TURKIYE-TR,DC=xx,DC=xx,DC=xx" –Properties * | ForEach-Object {

#Get-ADUser -Identity onurbabur -Properties *  | ForEach-Object {

    $dif = New-TimeSpan -Start ($_.PasswordLastSet).ToShortDateString()
    $temp = 60 - $dif.Days
    $kalangun = $temp -ge 15

    if($temp -eq 10 -or $temp -eq 9 -or $temp -eq 8 -or $temp -eq 7 -or $temp -eq 6 -or $temp -eq 5 -or $temp -eq 4 -or $temp -eq 3 -or $temp -eq 2 -or $temp -eq 1) {
               
             
             Write-Host $_.mail , $temp
                
            Send-MailMessage -To $_.Mail -From "Infra No-Reply <infra-noreply@onurbabur.com>" -BCC "Onur Babur <onur.babur@onurbabur.com>" -Subject "Parola Süresi Hatırlatma" -Body "Parolanızın süresinin dolmasına $temp gün kalmıştır. En kısa zamanda parolanızı değiştirmeniz gerekmektedir. `
           `n Not : 
            - Parolanız en az 8 karakterden oluşmalıdır. 
            - Parolanız son 5 parolanızdan biri olmamalıdır. 
            - Parolanızın içinde en az 3 ayrı karakter seti olmalıdır.(Büyük harf, küçük harf, rakam ve özel karakterler ayrı karakter setleridir.)
            
            Sifre Resetleme Yonergeleri:
 
            Dominos tarafında sistemlerimize baglanti saglamak icin kullanmis olduğunuz adm-xxxx  kullanici hesaplarinizin sifre sifirlama adimlari asagida ve linkte acik sekilde belirtilmiştir. Bundan sonraki sureclerde sifre sifirlamalari Dominos ekipleri tarafından yapilmayacaktir.
  
            (Asagidaki adimlari tamamlamayanlar icindir)
 
	        •	Oncelikle SSPR yani self service password reset üzerinde asagidaki linke giris yaparak kayit işlemi yapmaniz gerekmektedir.
 
                https://account.activedirectory.windowsazure.com/PasswordReset/Register.aspx?regref=ssprsetup
 
	        •	Asagidaki linkten sifrenizi yonergeleri takip ederek sms ve Microsoft Authenticator uygulamasi kullanarak sifirlayabilirsiniz.
  
 
                https://passwordreset.microsoftonline.com/
 
 
                        Veya
 
                https://xxxxx.klavuzu
 



           " `
            -SmtpServer "10.147.x.xx" -Encoding UTF8
  
    }
  
  }
