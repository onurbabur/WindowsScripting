$csvFolderPath = "C:\Users\adm-obabur\Desktop\BIReports"
$excelFilePath = "C:\Users\adm-obabur\Desktop\BIReports.xlsx"

# Excel uygulamasını oluştur
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

# Yeni bir Excel çalışma kitabı oluştur
$workbook = $excel.Workbooks.Add()

# CSV klasöründeki dosyaları al
$csvFiles = Get-ChildItem -Path $csvFolderPath -Filter "*.csv"

# Her CSV dosyası için
foreach ($csvFile in $csvFiles) {
    # Dosya adını al ve sheet adı olarak kullan
    $sheetName = $csvFile.BaseName

    # Yeni bir çalışma sayfası oluştur
    $worksheet = $workbook.Worksheets.Add()
    $worksheet.Name = $sheetName

    # CSV dosyasını oku
    $csvData = Import-Csv -Path $csvFile.FullName

    # Verileri Excel sayfasına aktar
    $rowIndex = 1
    foreach ($row in $csvData) {
        $columnIndex = 1
        foreach ($property in $row.PsObject.Properties) {
            $value = $property.Value
            $worksheet.Cells.Item($rowIndex, $columnIndex) = $value
            $columnIndex++
        }
        $rowIndex++
    }

    # İşlem tamamlandıktan sonra belleği temizle
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

# Excel dosyasını kaydet ve kapat
$workbook.SaveAs($excelFilePath)
$excel.Quit()

# Kullanılan kaynakları serbest bırak
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Host "İşlem tamamlandı."
