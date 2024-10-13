$GrpMembers = @(Get-ADGroupMember -identity "sec_RDSFarm_MosaicStd").SamAccountName
$DisabledMembers = @()
ForEach($GrpMember in $GrpMembers){
    $Disabled = (Get-ADUser -Identity $GrpMember -Properties * | Where-Object{$_.Enabled -eq $false} | Select-Object SamAccountName)
    $DisabledMembers += $Disabled
}
Write-host $DisabledMembers

Foreach($DisabledMember in $DisabledMembers){
    Write-host Removing Member : $DisabledMember
    Remove-ADGroupMember -Identity "sec_RDSFarm_MosaicStd" -Members $DisabledMember -Confirm:$false
    Remove-ADGroupMember -Identity "Sec_RMS-Riley_Client" -Members $DisabledMember -Confirm:$false
}

################################################################
# Remove Inactive Users
################################################################

$InactiveMembers = @(
    "hayden.veigel",
    "nancy.fernandes",
    "sarah.johnston",
    "isobel.lau",
    "yara.torbey",
    "michael.sedgwick",
    "jamicah.ignalig",
    "tee.lu",
    "maddison.mcqueen"
)

Foreach($InactiveMember in $InactiveMembers){
    Write-host Removing Member : $InactiveMember
    Remove-ADGroupMember -Identity "sec_RDSFarm_MosaicStd" -Members $InactiveMember -Confirm:$false
    Remove-ADGroupMember -Identity "Sec_RMS-Riley_Client" -Members $InactiveMember -Confirm:$false
}