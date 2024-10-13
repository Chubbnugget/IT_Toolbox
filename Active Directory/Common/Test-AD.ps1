# Import the CSV file containing the credentials
$credentials = Import-Csv -Path "C:\Users\Phil.Barrett\OneDrive - Mosaic Brands Limited\Documents\1. Code\Scripting\Acc.csv"

$BadCreds = @()
$GoodCreds = @()

# Loop through each credential in the CSV file
foreach ($credential in $credentials) {
    # Extract the username and password from the current credential
    $username = $credential.Username
    $password = $credential.Password
    # Write the username and password to the console
    Write-Host "Testing... :" -ForegroundColor Yellow
    Write-Host "Username: $username"
    Write-Host "Password: $password"

    $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
    $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)
    
    if ($domain.name -eq $null)
    {
    write-host "Authentication failed - please verify your username and password."
    $BadCreds += $username
    }
    else
    {
    write-host "Successfully authenticated with domain $domain.name"
    $GoodCreds += $username
    }
}

$BadCreds | Out-GridView
$GoodCreds | Out-GridView