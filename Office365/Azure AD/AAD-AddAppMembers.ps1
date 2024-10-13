############################################################################################
# Start Logging!
############################################################################################
# Specify the log directory
$logDirectory = "C:\Logs\AAD-AddAppMembers"

New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null

# Clean up log files older than 30 days
$cutOffDate = (Get-Date).AddDays(-30)
Get-ChildItem -Path $logDirectory -Filter *.log | Where-Object { $_.LastWriteTime -lt $cutOffDate } | ForEach-Object {
    Remove-Item $_.FullName -Force
}

# Start Logging!
$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$TranscriptFile = "$logDirectory\AAD-AddAppMembers-$Now.log"
Start-Transcript -Force -NoClobber -IncludeInvocationHeader -Path $TranscriptFile

Write-Output "[Info]: Log File Started"
Write-Host "[Info]: Log File Started" -ForegroundColor Cyan

############################################################################################
# Connect to Azure AD
############################################################################################

Connect-AzureAD

############################################################################################
# Get list of Azure AD Users & Application Members
############################################################################################

$licensedUsers = Get-AzureADUser -all $true | Where-Object {$_.AssignedLicenses} | Select displayname,objectid

$provisionedUsers = Get-AzureADApplication -all $true | Where-Object {$_.ObjectId -eq "a5c329ca-d5a5-4565-8933-a0cb0a0a21c8"} | Get-AzureADServicePrincipal | Get-AzureADServicePrincipalMembership | Select displayname,objectid





