##################################################################################################
# Scan AD for Users
##################################################################################################
$InactiveDate = ((Get-Date).AddDays(-30))
$ActiveDate = ((Get-Date).AddDays(-7))

$InactiveUsers= (Get-ADUser -SearchBase "DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName, DistinguishedName |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -AND ($_.DistinguishedName -notlike "*Stores*")} |
                    Select-Object Name, LastLogonDate, SamAccountName, DistinguishedName)

$ActiveUsers= (Get-ADUser -SearchBase "DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName,DistinguishedName |
                    Where-Object {($_.LastLogonDate -gt $ActiveDate) -AND ($_.DistinguishedName -notlike "*Stores*") -AND ($_.DistinguishedName -notlike "*Customer Care*") -AND ($_.DistinguishedName -notlike "*Ezibuy*") -AND ($_.DistinguishedName -notlike "*svc*") -AND ($_.DistinguishedName -notlike "*MSOL*") -AND ($_.DistinguishedName -notlike "*Service*") } |
                    Select-Object Name, LastLogonDate, SamAccountName, DistinguishedName)

$EnabledUsers= (Get-ADUser -SearchBase "DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName,DistinguishedName |
                    Where-Object {($_.DistinguishedName -notlike "*Customer Care*") -AND ($_.DistinguishedName -notlike "*Stores*") -AND ($_.DistinguishedName -notlike "*Ezibuy*") -AND ($_.DistinguishedName -notlike "*svc*") -AND ($_.DistinguishedName -notlike "*MSOL*") -AND ($_.DistinguishedName -notlike "*Service*") -AND ($_.DistinguishedName -notlike "*Meeting*") -AND ($_.DistinguishedName -notlike "*System Objects*")} |
                    Select-Object Name, LastLogonDate, SamAccountName, DistinguishedName)

$EnabledUsers | Out-GridView

$SSGUsers= (Get-ADUser -SearchBase "OU=Customer Care,OU=Mosaic Users,DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName,DistinguishedName |
                    Select-Object Name, LastLogonDate, SamAccountName, DistinguishedName)

$SSGUsers | Out-GridView

Write-Host ""
Write-Host Begin Inactive list
Write-Host ""

ForEach($InactiveUser in $InactiveUsers){
    Write-Host $InactiveUser.Name "|" $InactiveUser.LastLogonDate "|" $InactiveUser.lastLogonTimestamp "|" $InactiveUser.DistinguishedName
}

Write-Host ""
Write-Host Begin Active list
Write-Host ""

ForEach($ActiveUser in $ActiveUsers){
    Write-Host $ActiveUser.Name "|" $ActiveUser.LastLogonDate "|" $ActiveUser.lastLogonTimestamp "|" $InactiveUser.DistinguishedName
}

$InactiveUsers | Out-GridViewd
Write-Host ""
Write-Host "Total of" $InactiveUsers.Count "Inactive Users"  -ForegroundColor Cyan
Write-Host "Total of " $ActiveUsers.Count "Active Users" -ForegroundColor Cyan