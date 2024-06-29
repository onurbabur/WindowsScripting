# Gereken versiyonlar
$requiredVersions = @{
    "Microsoft OLE DB Driver 16 for SQL Server" = [version]"16.10.6.1"
    "Microsoft OLE DB Driver 17 for SQL Server" = [version]"17.10.6.1"
    "Microsoft OLE DB Driver 18 for SQL Server" = [version]"18.7.2"
    "Microsoft OLE DB Driver 19 for SQL Server" = [version]"19.10.6.1"
    "Microsoft OLE DB Driver for SQL Server"    = [version]"18.7.2"
}

# MSI dosyalarının yolları
$msiPaths = @{
    "Microsoft OLE DB Driver 16 for SQL Server" = "\\XXX\OLEDBSQL\msoledbsql16.7.2.msi"
    "Microsoft OLE DB Driver 17 for SQL Server" = "\\XXX\OLEDBSQL\msoledbsql17.3.3.msi"
    "Microsoft OLE DB Driver 18 for SQL Server" = "\\XXX\OLEDBSQL\msoledbsql18.7.2.msi"
    "Microsoft OLE DB Driver 19 for SQL Server" = "\\XXX\OLEDBSQL\msoledbsql19.3.3.msi"
    "Microsoft OLE DB Driver for SQL Server" = "\\XXX\OLEDBSQL\msoledbsql18.7.2.msi"
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