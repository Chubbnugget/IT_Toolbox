# Import the required module for Get-NetTCPConnection cmdlet
Import-Module NetTCPIP

# Get all listening ports and associated processes
$listeningPorts = Get-NetTCPConnection | Where-Object { $_.State -eq 'Listen' }

# Create an array to store custom objects for each application
$applicationInfo = @()

# Iterate through each listening port and retrieve process information
foreach ($port in $listeningPorts) {
    $processId = $port.OwningProcess
    $process = Get-Process -Id $processId

    # Create a custom object for each application
    $appInfo = [PSCustomObject]@{
        'ProcessId' = $processId
        'ProcessName' = $process.Name
        'Port' = $port.LocalPort
        'State' = $port.State  # Add this line
    }

    $applicationInfo += $appInfo
}

# Output the application information
$applicationInfo | Format-Table -AutoSize