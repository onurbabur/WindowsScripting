Import-Module GroupPolicy

(Get-GPO -All | Sort-Object DisplayName | Select-Object DisplayName).DisplayName > C:\Onur\gponames.csv

$dName = "dominos.com.tr"
$sName = "DPPRODDC02"

$gpos = Get-Content -Path "C:\Onur\gponames.csv"

foreach ($gpo in $gpos) {

Get-GPOReport -Name $gpo -Domain $dName -Server $sName -ReportType Html -Path "C:\Onur\GPOs\$($gpo -replace ':','-' -replace '/','-' -replace ',','-').html"

}