# Specify the source and destination OUs
$sourceOU = "OU=DisabledUsers,DC=example,DC=com"
$destinationOU = "OU=NewUsers,DC=example,DC=com"

# Get all disabled users from the source OU
$disabledUsers = Get-ADUser -SearchBase $sourceOU -Filter {Enabled -eq $false}

# Move each disabled user to the destination OU
foreach ($user in $disabledUsers) {
    Move-ADObject -Identity $user.DistinguishedName -TargetPath $destinationOU
}
