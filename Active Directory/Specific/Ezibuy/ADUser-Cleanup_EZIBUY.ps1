##################################################################################################
# Set Logging
##################################################################################################
$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$InactiveDate = ((Get-Date).AddDays(-30))
$TranscriptFile = "C:\Logs\ComputerCleanup-" + $Now + ".log"
Start-Transcript -Force -NoClobber -IncludeInvocationHeader -Path $TranscriptFile 

##################################################################################################
# Scan AD for Users
##################################################################################################
$InactiveDate = ((Get-Date).AddDays(-30))
$ActiveDate = ((Get-Date).AddDays(-7))

$InactiveUsers= (Get-ADUser -SearchBase "DC=ezibuy,DC=internal" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.DistinguishedName -notlike "*svc*") -and ($_.DistinguishedName -notlike "*sys*") -and ($_.DistinguishedName -notlike "*Special*") -and ($_.DistinguishedName -notlike "*Shop*") -and ($_.DistinguishedName -notlike "*stock*") -and ($_.DistinguishedName -notlike "*admin*") -and ($_.DistinguishedName -notlike "*mail*")} |
                    Select-Object Name, LastLogonDate, SamAccountName)

$ActiveUsers= (Get-ADUser -SearchBase "DC=ezibuy,DC=internal" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName |
                    Where-Object {($_.LastLogonDate -gt $ActiveDate) -and ($_.DistinguishedName -notlike "*svc*") -and ($_.DistinguishedName -notlike "*sys*") -and ($_.DistinguishedName -notlike "*Special*")} |
                    Select-Object Name, LastLogonDate, SamAccountName)

Write-Host ""
Write-Host Begin Inactive list
Write-Host ""

ForEach($InactiveUser in $InactiveUsers){
    Write-Host $InactiveUser.Name "|" $InactiveUser.LastLogonDate "|" $InactiveUser.lastLogonTimestamp
}

Write-Host ""
Write-Host Begin Active list
Write-Host ""

ForEach($ActiveUser in $ActiveUsers){
    Write-Host $ActiveUser.Name "|" $ActiveUser.LastLogonDate "|" $ActiveUser.lastLogonTimestamp
}


Write-Host ""
Write-Host "Total of" $InactiveUsers.Count "Inactive Users"  -ForegroundColor Cyan
Write-Host "Total of " $ActiveUsers.Count "Active Users" -ForegroundColor Cyan

##################################################################################################
# Create Undo Command list
##################################################################################################
$csvFilePath = "C:\Temp\ADCleanupRollback.csv"
$RollbackData = @()

ForEach($InactiveUser in $InactiveUsers){
    Write-Host "Preparing Rollback for" $InactiveUser -ForegroundColor Yellow
    $RollbackCommand = "Set-ADUser -Identity $($InactiveUser.SamAccountName) -Enabled $true -Verbose"
    
    # Create a custom object for the command and add it to the array
    $RollbackData += [PSCustomObject]@{
        User = $InactiveUser.SamAccountName
        Command = $RollbackCommand
    }

    Write-Host "Done"
}

$RollbackData | Export-Csv -Path $csvFilePath -NoTypeInformation
##################################################################################################
# Cleanup Inactive Users
##################################################################################################
ForEach($InactiveUser in $InactiveUsers){
    Write-Host "Cleaning the following :" -ForegroundColor Red
    Write-Host $InactiveUser.Name "|" $InactiveUser.LastLogonDate
    Try {
        $NewDescription = $InactiveUser.Description + "# Disabled (Inactive) " + $Now + "#"
        Write-Host Disabling $InactiveUser.Name and setting Description: $NewDescription
        Set-ADUser -Identity $InactiveUser.SamAccountName -Enabled $False -Description $NewDescription -Verbose # Disable the user account and update the description
            # Log Success Status

            $Details = @{ 
             LastLogonDate = $InactiveUser.LastLogonDate
             Name = $InactiveUser.Name
             Status = "Success"
            }
        }
    Catch {
        Write-Host Error disabling for $InactiveUser.Name
    
        # Log Error
        $Details = @{
        LastLogonDate = $InactiveUser.LastLogonDate
        Name = $InactiveUser.Name
        Status = "Failed"
        }
    }
}
Stop-Transcript
#FIN