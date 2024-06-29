# Gereken versiyonlar
$requiredVersions = @{
    "Microsoft ODBC Driver 16 for SQL Server" = [version]"16.10.6.1"
    "Microsoft ODBC Driver 17 for SQL Server" = [version]"17.10.6.1"
    "Microsoft ODBC Driver 18 for SQL Server" = [version]"18.3.3.1"
    "Microsoft ODBC Driver 19 for SQL Server" = [version]"19.10.6.1"
}

# MSI dosyalarının yolları
$msiPaths = @{
    "Microsoft ODBC Driver 16 for SQL Server" = "\\XXX\ODBCSQL\msodbcsql16.10.6.msi"
    "Microsoft ODBC Driver 17 for SQL Server" = "\\XXX\ODBCSQL\msodbcsql17.10.6.msi"
    "Microsoft ODBC Driver 18 for SQL Server" = "\\XXX\ODBCSQL\msodbcsql18.3.3.1.msi"
    "Microsoft ODBC Driver 19 for SQL Server" = "\\XXX\ODBCSQL\msodbcsql19.10.6.msi"
}

# Geçici dizin
$tempDir = "C:\Windows\Temp"

# Her bir driver sürümü için kontrol et
foreach ($driverName in $requiredVersions.Keys) {
    $odbcDriver = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = '$driverName'"

    if ($odbcDriver) {
        $currentVersion = [version]$odbcDriver.Version
        Write-Host "$driverName is installed."
        Write-Host "Current Version: $currentVersion"

        if ($currentVersion -lt $requiredVersions[$driverName]) {
            Write-Host "Updating $driverName to version $($requiredVersions[$driverName])..."

            # Kaynak ve hedef yolları
            $sourcePath = $msiPaths[$driverName]
            $destinationPath = Join-Path -Path $tempDir -ChildPath (Split-Path -Leaf $sourcePath)

            # MSI dosyasını kopyala
            Copy-Item -Path $sourcePath -Destination $destinationPath -Force

            # Kurulumu başlat
            Start-Process msiexec.exe -ArgumentList "/i `"$destinationPath`" /quiet /norestart" -Wait
           

            Write-Host "Update completed."
        } else {
            Write-Host "$driverName is up-to-date."
        }
    } else {
        Write-Host "$driverName is not installed."
    }
}
