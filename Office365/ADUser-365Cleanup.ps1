################################################################
# Clean Out Ground Floor Group
################################################################
$GrpMembers = @(Get-ADGroupMember -identity "Rosebery Team GF-1-711727661").SamAccountName
$DisabledMembers = @()
ForEach($GrpMember in $GrpMembers){
    $Disabled = (Get-ADUser -Identity $GrpMember -Properties * | Where-Object{$_.Enabled -eq $false} | Select-Object SamAccountName)
    $DisabledMembers += $Disabled
}

Write-host $DisabledMembers

Foreach($DisabledMember in $DisabledMembers){
    Write-host Removing Member : $DisabledMember
    Remove-ADGroupMember -Identity "Rosebery Team GF-1-711727661" -Members $DisabledMember -Confirm:$false
}

################################################################
# Clean out Level 3 Group
################################################################

$GrpMembers = @(Get-ADGroupMember -identity "Rosebery Team L3-1890673514").SamAccountName
$DisabledMembers = @()
ForEach($GrpMember in $GrpMembers){
    $Disabled = (Get-ADUser -Identity $GrpMember -Properties * | Where-Object{$_.Enabled -eq $false} | Select-Object SamAccountName)
    $DisabledMembers += $Disabled
}

Write-host $DisabledMembers

Foreach($DisabledMember in $DisabledMembers){
    Write-host Removing Member : $DisabledMember
    Remove-ADGroupMember -Identity "Rosebery Team L3-1890673514" -Members $DisabledMember -Confirm:$false
}

################################################################
# Clean out E3
################################################################

$GrpMembers = @(Get-ADGroupMember -identity "sec_License_Office365_E3").SamAccountName
$DisabledMembers = @()
ForEach($GrpMember in $GrpMembers){
    $Disabled = (Get-ADUser -Identity $GrpMember -Properties * | Where-Object{$_.Enabled -eq $false} | Select-Object SamAccountName)
    $DisabledMembers += $Disabled
}

Write-host $DisabledMembers

Foreach($DisabledMember in $DisabledMembers){
    Write-host Removing Member : $DisabledMember
    Remove-ADGroupMember -Identity "sec_License_Office365_E3" -Members $DisabledMember -Confirm:$false
}
################################################################
# Remove Inactive Users
################################################################
<#
$InactiveMembers = @()

Foreach($InactiveMember in $InactiveMembers){
    Write-host Removing Member : $InactiveMember
    Remove-ADGroupMember -Identity "sec_License_Office365_E3" -Members $InactiveMember -Confirm:$false
}
#>

