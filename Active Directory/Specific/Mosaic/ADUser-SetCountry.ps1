$NZStores = @(Get-ADGroupMember -Identity "All New Zealand Stores-1740695438").SamAccountName
$AUStores = @(Get-ADGroupMember -Identity "All Australian Stores-1-556433495").SamAccountName

Foreach($NZStore in $NZStores){
    Set-ADUser -Identity $NZStore -Replace @{c="NZ";co="New Zealand";countrycode="554"} -Verbose
    Write-Host Setting NZ Country for $NZStore
}

Foreach($AUStore in $AUStores){
    Set-ADUser -Identity $AUStore -Replace @{c="AU";co="Australia";countrycode="36"} -Verbose
    Write-Host Setting AU Country for $AUStore
}