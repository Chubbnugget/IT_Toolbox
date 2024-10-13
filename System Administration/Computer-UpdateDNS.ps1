###############################################################################
# Script to Update DNS settings on Network Adapters
###############################################################################
#Random wait time to avoid network congestion
$rng = Get-Random -Minimum 1 -Maximum 120
Start-Sleep -Seconds $rng
# Get Adapter 
$ActiveAdapter = Test-NetConnection -ComputerName www.google.com | Select-Object -ExpandProperty InterfaceAlias
$NetAdapter = Get-NetAdapter | Where-Object {$_.Name -eq $ActiveAdapter} | Select-Object -Property Name, InterfaceIndex, status,

# Display Current Settings
$CurrentDNS = Get-DnsClientServerAddress -InterfaceIndex $NetAdapter.InterfaceIndex -AddressFamily IPv4 | Select-Object -ExpandProperty ServerAddresses
Write-Host "Current Settings : $CurrentDNS"

# Define correct settings
$CorrectDNS = @("172.20.11.5","172.20.11.6","172.20.58.101","172.20.57.102","1.1.1.1")
Write-Host "Correct Settings : $CorrectDNS"

# Compare current settings with correct settings
$ComparisonResult = Compare-Object $CurrentDNS $CorrectDNS -SyncWindow 0 -IncludeEqual:$false

$DNSisCorrect = if ($ComparisonResult -ne $null) { $false } else { $true }

# Set DNS if not correct
if ($DNSisCorrect -eq $true) {
    Write-Host "DNS is already set correctly"
} else {
    Write-Host "Setting DNS to 172.20.11.5 172.20.11.6 172.20.58.101 172.20.58.102 1.1.1.1"
    Set-DnsClientServerAddress -InterfaceIndex $NetAdapter.InterfaceIndex -ServerAddresses ("172.20.11.5","172.20.11.6","172.20.58.101","172.20.57.102","1.1.1.1") 
}

# Post to Azure Logic App
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ComputerName = $env:COMPUTERNAME
$TimeStamp = Get-Date
$DNSBefore = $CurrentDNS -join ","
$DNSNow = Get-DnsClientServerAddress -InterfaceIndex $NetAdapter.InterfaceIndex -AddressFamily IPv4 | Select-Object -ExpandProperty ServerAddresses
$DNSNow = $DNSNow -join ","
$ChangesMade = if ($DNSisCorrect -eq $true) { "No" } else { "Yes" }

$Output = "[{`"ComputerName`":`"" + $ComputerName + "`",
             `"TimeStamp`":`"" + $TimeStamp.ToString("dd/MM/yyyy hh:mm:ss") + "`",
             `"DNS_Before`":`"" + $DNSBefore + "`",
             `"DNS_After`":`"" + $DNSNow + "`",
             `"ChangesMade`":`"" + $ChangesMade + "`"}]"

$URL = "https://prod-00.australiasoutheast.logic.azure.com:443/workflows/0b581f9ddeba4084a0d09712c1145c1e/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=OmIbn_SaazbpWm7c_US-j30eHN2Cw5g68SzPNXHwnsg"

invoke-WebRequest -Uri $URL -Method POST -Body $Output -ContentType 'application/json'