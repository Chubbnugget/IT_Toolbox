############################################################################################
# Start Logging!
############################################################################################

New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null

# Specify the log directory
$logDirectory = "C:\Logs\"

# Start Logging!
$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$TranscriptFile = "$logDirectory\PA-Test-$Now.log"
Start-Transcript -Force -NoClobber -IncludeInvocationHeader -Path $TranscriptFile

Write-Output "[Info]: Log File Started"
Write-Host "[Info]: Log File Started" -ForegroundColor Cyan

############################################################################################
function Exit-Script {
    Write-Host "[Info]: Script will now cleanup and exit..." -ForegroundColor Cyan
    Write-Output "[Info]: Script will now cleanup and exit..."
    Stop-Transcript
    Write-Host "[Info]: Log file has been saved as" $TranscriptFile -ForegroundColor Cyan
    Write-Output "[Info]: Log file has been saved as" $TranscriptFile
    Exit
}

# Read the RDSSelectFormData variable
$RDSSelectFormData = Get-Variable -Name "RDSSelectFormData" -ValueOnly

Write-Output $RDSSelectFormData

# Iterate over the server names and True/False values
foreach ($server in $RDSSelectFormData) {
    $serverName = $server.Name
    $isEnabled = $server.Value

    if ($isEnabled) {
        $discSessions = @(qwinsta /server:$serverName | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

        foreach ($sessionID in $discSessions) {
            if ($sessionID -ne "0") {
                rwinsta /server:$serverName $sessionID
            }
        }
        $discSessions = @()
    }
}