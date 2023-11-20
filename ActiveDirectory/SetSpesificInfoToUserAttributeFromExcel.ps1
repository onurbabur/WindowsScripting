# Import the Active Directory module
Import-Module ActiveDirectory
 
# Specify the path to your Excel file
$excelFilePath = "D:\TEST\test3.xlsx"
 
# Load the Excel file
$excelData = Import-Excel -Path $excelFilePath
 
# Loop through each row in the Excel file
foreach ($row in $excelData) {
    # Extract email address and PersonelNo from the Excel row
    $email = $row.EmailAddress
    $personelNo = $row.PersonelNo -as [string]  # Convert to string explicitly
 
    # Search for the user in Active Directory based on the email address
    $user = Get-ADUser -Filter {EmailAddress -eq $email} -Properties EmailAddress, PersonelNo
 
    # Check if the user was found
    if ($user) {
        # Update the PersonelNo attribute
        Set-ADUser -Identity $user.SamAccountName -Replace @{PersonelNo = $personelNo}
        Write-Host "Updated PersonelNo for $($user.SamAccountName) with value $($personelNo)"
    } else {
        Write-Host "User with email address $($email) not found in Active Directory."
    }
}