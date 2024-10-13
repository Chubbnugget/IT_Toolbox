##################################################################################################
# Set Logging
##################################################################################################
$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$TranscriptFile = "C:\Logs\UpdateGroupMembership-" + $Now + ".log"
Start-Transcript -Force -NoClobber -IncludeInvocationHeader -Path $TranscriptFile

##################################################################################################
# Scan AD for Computers
##################################################################################################

$StoreUsers = (Get-ADUser -SearchBase "OU=Stores,DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName |
                Where-Object {($_.DistinguishedName -notlike "*zzzDisabledAccounts*")} |
                Select-Object SamAccountName)

$AUStoreUsers = (Get-ADUser -SearchBase "OU=Stores,DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName |
                Where-Object {($_.DistinguishedName -notlike "*zzzDisabledAccounts*")} |
                Select-Object SamAccountName)

$NZStoreUsers = (Get-ADUser -SearchBase "OU=Stores,DC=internal,DC=retail" -Filter {Enabled -eq $true} -Properties Name, LastLogonDate, Description, SamAccountName |
                Where-Object {($_.DistinguishedName -notlike "*zzzDisabledAccounts*")} |
                Select-Object SamAccountName)

$DisabledUsers = (Get-ADUser -SearchBase "OU=Stores,DC=internal,DC=retail" -Filter {Enabled -eq $false} -Properties Name, LastLogonDate, Description, SamAccountName |
                Select-Object SamAccountName)
        
$AllGrpMembers = @(Get-ADGroupMember -identity "All Australian Stores-1-556433495" | Select-object SamAccountName)
$AUGrpMembers = @(Get-ADGroupMember -identity "All New Zealand Stores-1740695438" | Select-object SamAccountName)
$NZGrpMembers = @(Get-ADGroupMember -identity "All Stores-11099595408" | Select-object SamAccountName)

$NZStores = @(Get-ADGroupMember -Identity "All New Zealand Stores-1740695438" | Select-Object SamAccountName)

$MissingAUMembers = (Compare-Object -ReferenceObject $AUStoreUsers -DifferenceObject $AUGrpMembers -PassThru).SamAccountName
$MissingNZMembers = (Compare-Object -ReferenceObject $NZStoreUsers -DifferenceObject $NZGrpMembers -PassThru).SamAccountName
$MissingMembers = (Compare-Object -ReferenceObject $StoreUsers -DifferenceObject $AllGrpMembers -PassThru).SamAccountName

Write-Host $DisabledUsers.Count : Disabled Users
Write-Host $MissingMembers
Write-Host $MissingMembers.Count

##################################################################################################
# Remove Disabled Stores From Group Membership
##################################################################################################
Foreach($DisabledUser in $DisabledUsers){
    Remove-ADGroupMember -Identity "All Australian Stores-1-556433495" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All New Zealand Stores-1740695438" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All BeMe Combo Stores-1649039490" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All BeMe Combo Stores-1649039490" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All Autograph Stores-1-1106992594" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All Noni B Stores-12008220792" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All Emporium Stores-11539975614" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All Rockmans Stores-12011223042" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All Rivers Stores-1168561110" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All WLane Stores-174364752" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All WLane Combo Stores-1-1411782762" -Members $DisabledUser -Confirm:$false -Verbose
    Remove-ADGroupMember -Identity "All Stores-11099595408" -Members $DisabledUser -Confirm:$false -Verbose
}

##################################################################################################
# Add Current Stores to Group Membership
##################################################################################################

Foreach($MissingMember in $MissingMembers){
    Write-host Adding Member : $MissingMember
    Add-ADGroupMember -Identity "All Stores-11099595408" -Members $MissingMember -Confirm:$false -Verbose -DisablePermissiveModify
}

Foreach($MissingNZMember in $MissingNZMembers){
    Write-host Adding Member : $MissingMember
    Add-ADGroupMember -Identity "All New Zealand Stores-1740695438" -Members $MissingNZMember -Confirm:$false -Verbose -DisablePermissiveModify
}

Foreach($MissingAUMember in $MissingAUMembers){
    Write-host Adding Member : $MissingMember
    Add-ADGroupMember -Identity "All Australian Stores-1-556433495" -Members $MissingAUMember -Confirm:$false -Verbose -DisablePermissiveModify
}

Foreach($NZStore in $NZStores){
    Remove-ADGroupMember -Identity "All Australian Stores-1-556433495" -Members $NZStore -Confirm:$false -Verbose
}

Stop-Transcript
#FIN

#All Stores-11099595408