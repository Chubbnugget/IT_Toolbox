$OUList = (Get-ADUser -SearchBase "OU=Office 365 Sync,OU=Mosaic Users,DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName,DistinguishedName |
Where-Object {($_.DistinguishedName -notlike "*O365 Sync_No Licence*") -AND ($_.DistinguishedName -notlike "*Ezibuy IT*") -AND ($_.DistinguishedName -notlike "*Service Accounts*")} |
Select-Object Name, LastLogonDate, Description, SamAccountName, DistinguishedName)

$DistList1 = @(Get-ADGroupMember -identity "Rosebery Team L3-1890673514" | Select-object Name, LastLogonDate, Description, SamAccountName, DistinguishedName)
$DistList2 = @(Get-ADGroupMember -identity "Rosebery Team GF-1-711727661" | Select-object Name, LastLogonDate, Description, SamAccountName, DistinguishedName)

$OUList | Out-GridView
$DistList1 | Out-GridView
$DistList2 | Out-GridView

Write-Host $OUList.Count "In New Group"
Write-Host $DistList1.Count "Currently In L3 Group"
Write-Host $DistList2.Count "Currently in GF Group"