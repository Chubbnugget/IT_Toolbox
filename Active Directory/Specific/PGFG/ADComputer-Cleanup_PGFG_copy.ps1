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
$InactiveDate = ((Get-Date).AddDays(-30))

$StoreComputers= (Get-ADComputer -SearchBase "OU=Computers - Stores,DC=pgfg,DC=prettygirl,DC=com,DC=au" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, OperatingSystem |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.OperatingSystem -notlike "Mac") -and ($_.DistinguishedName -notlike "*(Remote)*")-and ($_.DistinguishedName -notlike "*Spares*") -and ($_.DistinguishedName -notlike "*Staged*")} |
                    Select-Object Name, LastLogonDate)

ForEach($StoreComputer in $StoreComputers){
    Write-Host $StoreComputer.Name "|" $StoreComputer.LastLogonDate
}

$HOComputers= (Get-ADComputer -SearchBase "CN=Computers,DC=pgfg,DC=prettygirl,DC=com,DC=au" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, OperatingSystem |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.OperatingSystem -notlike "Mac") -and ($_.DistinguishedName -notlike "*(Remote)*") -and ($_.DistinguishedName -notlike "*Spares*") -and ($_.DistinguishedName -notlike "*Staged*") -and ($_.DistinguishedName -notlike "*mac*") -and ($_.DistinguishedName -notlike "*SVR*") } |
                    Select-Object Name, LastLogonDate)

Write-Host ""
ForEach($HOComputer in $HOComputers){
    Write-Host $HOComputer.Name "|" $HOComputer.LastLogonDate
}
Write-Host ""
Write-Host Detected $HOComputers.Count Head Office and $StoreComputers.Count Store Computers -ForegroundColor Cyan
Write-Host Total of ($StoreComputers.Count+$HOComputers.Count) Inactive Computers -ForegroundColor Cyan

##################################################################################################
# Scan AD for Users
##################################################################################################
$InactiveDate = ((Get-Date).AddDays(-30))

$StoreUsers= (Get-ADUser -SearchBase "OU=Stores,DC=pgfg,DC=prettygirl,DC=com,DC=au" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.DistinguishedName -notlike "*(Remote)*")} |
                    Select-Object Name, LastLogonDate, SamAccountName)

ForEach($StoreUser in $StoreUsers){
    Write-Host "User:" $StoreUser.Name "| Last Logon:" $StoreUser.LastLogonDate "| Last Modified:" $StoreUser.Modified
}

$OtherUsers= (Get-ADUser -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, Samaccountname |
                    Where-Object {($_.LastLogonDate -le $InactiveDate) -and ($_.DistinguishedName -notlike "*(Remote)*") -and ($_.DistinguishedName -notlike "*,OU=Stores,DC=pgfg,DC=prettygirl,DC=com,DC=au") -and ($_.DistinguishedName -notlike "*adm*") -and ($_.DistinguishedName -notlike "*.1*") -and ($_.DistinguishedName -notlike "*administrator*") -and ($_.DistinguishedName -notlike "*1*")} |
                    Select-Object Name, LastLogonDate, SamAccountName)

Write-Host ""
ForEach($OtherUser in $OtherUsers){
    Write-Host "User:" $OtherUser.Name "| Last Logon:" $OtherUser.LastLogonDate "| Last Modified:" $OtherUser.Modified
}
Write-Host ""
Write-Host Detected $OtherUsers.Count Head Office and $StoreUsers.Count Store Users -ForegroundColor Cyan
Write-Host Total of ($StoreUsers.Count+$OtherUsers.Count) Inactive Users -ForegroundColor Cyan

##################################################################################################
# Cleanup Inactive Users
##################################################################################################
ForEach($StoreUser in $StoreUsers){
    Write-Host "Cleaning the following :" -ForegroundColor Red
    Write-Host $StoreUser.Name "|" $StoreUser.LastLogonDate
    Try {
    $NewDescription = $StoreUser.Description + "# Disabled (Inactive) " + $Now + "#"
    Write-Host Disabling $StoreUser.Name and setting Description: $NewDescription
    Set-ADUser -Identity $StoreUser.SamAccountName -Enabled $False -Description $NewDescription -Verbose # Disable the user account and update the description
        # Log Success Status

        $Details = @{ 
            LastLogonDate = $StoreUser.LastLogonDate
            Name = $StoreUser.Name
            Status = "Success"
            }
        }
    Catch {
        Write-Host Error disabling for $StoreUser.Name
    
        # Log Error
        $Details = @{
        LastLogonDate = $StoreUser.LastLogonDate
        Name = $StoreUser.Name
        Status = "Failed"
    }
}

}

ForEach($OtherUser in $OtherUsers){
    Write-Host "Cleaning the following :" -ForegroundColor Red
    Write-Host $OtherUser.Name "|" $StoreUser.LastLogonDate
    Try {
    $NewDescription = $OtherUser.Description + "# Disabled (Inactive) " + $Now + "#"
    Write-Host Disabling $OtherUser.Name and setting Description: $NewDescription
    Set-ADUser -Identity $OtherUser.SamAccountName -Enabled $False -Description $NewDescription -Verbose # Disable the user account and update the description
        # Log Success Status

        $Details = @{ 
            LastLogonDate = $OtherUser.LastLogonDate
            Name = $OtherUser.Name
            Status = "Success"
            }
        }
    Catch {
        Write-Host Error disabling for $OtherUser.Name
    
        # Log Error
        $Details = @{
        LastLogonDate = $OtherUser.LastLogonDate
        Name = $OtherUser.Name
        Status = "Failed"
    }
}
}
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