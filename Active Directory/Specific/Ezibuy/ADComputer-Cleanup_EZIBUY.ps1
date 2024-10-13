##################################################################################################
# Set Logging
##################################################################################################
$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$InactiveDate = ((Get-Date).AddDays(-30))
$TranscriptFile = "C:\Logs\ComputerCleanup-" + $Now + ".log"
Start-Transcript -Force -NoClobber -IncludeInvocationHeader -Path $TranscriptFile 

##################################################################################################
# Scan AD for Computers
##################################################################################################

$Computers= (Get-ADComputer -SearchBase "OU=Workstations,DC=ezibuy,DC=internal" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, OperatingSystem |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.OperatingSystem -notlike "Mac") -and ($_.DistinguishedName -notlike "*(Remote)*")-and ($_.DistinguishedName -notlike "*Spares*") -and ($_.DistinguishedName -notlike "*Staged*")} |
                    Select-Object Name, LastLogonDate)

ForEach($StoreComputer in $StoreComputers){
    Write-Host $StoreComputer.Name "|" $StoreComputer.LastLogonDate
}

$Servers= (Get-ADComputer -SearchBase "OU=Workstations - SCCM,DC=ezibuy,DC=internal" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, OperatingSystem |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.OperatingSystem -notlike "Mac") -and ($_.DistinguishedName -notlike "*(Remote)*")-and ($_.DistinguishedName -notlike "*Spares*") -and ($_.DistinguishedName -notlike "*Staged*") -and ($_.DistinguishedName -notlike "*mac*")} |
                    Select-Object Name, LastLogonDate)

$SCCMComputers= (Get-ADComputer -SearchBase "OU=Workstations - SCCM,DC=ezibuy,DC=internal" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, OperatingSystem |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.OperatingSystem -notlike "Mac") -and ($_.DistinguishedName -notlike "*(Remote)*")-and ($_.DistinguishedName -notlike "*Spares*") -and ($_.DistinguishedName -notlike "*Staged*") -and ($_.DistinguishedName -notlike "*mac*")} |
                    Select-Object Name, LastLogonDate)

Write-Host ""
ForEach($Computer in $Computers){
    Write-Host $Computer.Name "|" $Computer.LastLogonDate
}
Write-Host ""
Write-Host ""
ForEach($SCCMComputer in $SCCMComputers){
    Write-Host $SCCMComputer.Name "|" $SCCMComputer.LastLogonDate
}
Write-Host ""
Write-Host ""
ForEach($Server in $Servers){
    Write-Host $Server.Name "|" $Server.LastLogonDate
}
Write-Host ""
Write-Host "Detected "$Computers.Count" Computers and "$SCCMComputers.Count" Computers in SCCM" -ForegroundColor Cyan
Write-Host "Total of "($Computers.Count+$SCCMComputers.Count+$Servers.Count)" Inactive Computers/Servers" -ForegroundColor Cyan

##################################################################################################
# Cleanup Inactive Devices
##################################################################################################
ForEach($StoreComputer in $StoreComputers){
    Write-Host "Cleaning the following :" -ForegroundColor Red
    Write-Host $StoreComputer.Name "|" $StoreComputer.LastLogonDate
    Try {
    $NewDescription = $StoreComputer.Description + "# Disabled (Inactive) " + $Now + "#"
    Write-Host Disabling $StoreComputer.Name and setting Description: $NewDescription
    Set-ADComputer -Identity $StoreComputer.Name -Enabled $False -Description $NewDescription -Verbose # Disable the computer account and update the description
        # Log Success Status

        $Details = @{ 
            LastLogonDate = $StoreComputer.LastLogonDate
            Name = $StoreComputer.Name
            Status = "Success"
            }
        }
    Catch {
        Write-Host Error disabling for $StoreComputer.Name
    
        # Log Error
        $Details = @{
        LastLogonDate = $StoreComputer.LastLogonDate
        Name = $StoreComputer.Name
        Status = "Failed"
    }
}
}

# HO Computers

ForEach($HOComputer in $HOComputers){
    Write-Host "Cleaning the following :" -ForegroundColor Red
    Write-Host $HOComputer.Name "|" $HOComputer.LastLogonDate
    Try {
    $NewDescription = $HOComputer.Description + "# Disabled (Inactive) " + $Now + "#"
    Write-Host Disabling $HOComputer.Name and setting Description: $NewDescription
    Set-ADComputer -Identity $HOComputer.Name -Enabled $False -Description $NewDescription -Verbose # Disable the computer account and update the description
        # Log Success Status

        $Details = @{ 
            LastLogonDate = $HOComputer.LastLogonDate
            Name = $HOComputer.Name
            Status = "Success"
            }
            
        }
    Catch {
        Write-Host Error disabling for $HOComputer.Name
    
        # Log Error
        $Details = @{
        LastLogonDate = $HOComputer.LastLogonDate
        Name = $HOComputer.Name
        Status = "Failed"
    }
}
}

Stop-Transcript
#FIN