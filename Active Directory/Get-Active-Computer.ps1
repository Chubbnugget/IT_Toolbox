# Import the Active Directory module
Import-Module ActiveDirectory

# Get all computers from the domain
$computers = Get-ADComputer -Filter * -Property *

# Export the results to a grid view
$computers | Out-GridView