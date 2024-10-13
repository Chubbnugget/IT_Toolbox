# Enable Remote Mailbox for new store/user
Enable-RemoteMailbox -Identity XXXX@mosaicbrandsltd.com.au -RemoteRoutingAddress XXXX@mosaicbrandsltd.onmicrosoft.com

# Create Remote Mailbox for Conference Room
New-RemoteMailbox -Alias RoomWon -FirstName "Room" -LastName "Won" -DisplayName "Room Won" -UserPrincipalName RoomWon@mosaicbrandsltd.com.au -OnPremisesOrganizationalUnit "Mosaic Room Mailboxes" -Room

# Start Azure AD Sync
Invoke-command -scriptblock {Start-ADSyncSyncCycle} -computername SVR-AADC01.internal.retail


#Lists users with numbers in their emails
$Users = @(Get-ADUser -Filter * -Properties SamAccountName,ProxyAddresses,Department,LastLogonDate)
$FilteredUsers = @(ForEach ($User in $Users) {
    Where-Object {$User.ProxyAddresses -cmatch "^SMTP:.\D"} | Select-Object -Property proxyaddresses,Department,LastLogonDate
    }
)
Write-Host $FilteredUsers


Get-ADUser -Filter * -Properties   | Select-Object  @{Name="LastLogonDate";Expression={$_.LastLogonDate.ToShortDateString()}},Name,Department, @{L = "ProxyAddresses"; E = { ($_.ProxyAddresses -cmatch '^SMTP:.\D').TrimStart('SMTP:')}}|Export-Csv -Path C:\Temp\AdUsersProxyAddresses.csv -NoTypeInformation

# Enable Shared Remote Mailbox

Invoke-command -scriptblock {
    Enable-RemoteMailbox -Identity Sales.Audit@mosaicbrandsltd.com.au -RemoteRoutingAddress Sales.Audit@mosaicbrandsltd.onmicrosoft.com -Shared
    Enable-RemoteMailbox -Identity Marketplaces_CA@mosaicbrandsltd.com.au -RemoteRoutingAddress Marketplaces_CA@mosaicbrandsltd.onmicrosoft.com -Shared
    Enable-RemoteMailbox -Identity Marketplaces_DE@mosaicbrandsltd.com.au -RemoteRoutingAddress Marketplaces_DE@mosaicbrandsltd.onmicrosoft.com -Shared
    Enable-RemoteMailbox -Identity Marketplaces_NL@mosaicbrandsltd.com.au -RemoteRoutingAddress Marketplaces_NL@mosaicbrandsltd.onmicrosoft.com -Shared
} -computername SVR-EXCH01.internal.retail

# Kick people off RDS

qwinsta /server:SVR-RDS01
qwinsta /server:SVR-RDS02
qwinsta /server:SVR-RDS03
qwinsta /server:SVR-RDS04
qwinsta /server:SVR-RDS05
qwinsta /server:SVR-RDS06



$discSessions = @(qwinsta /server:SVR-RDS04 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS04 $sessionID
    }
}
$discSessions = @()

$discSessions = @(qwinsta /server:SVR-RDS03 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS03 $sessionID
    }
}

https://mosaicbrandsltd.sharepoint.com/:f:/s/TechPack/EildJGkFIaRFtO2FlU2kla8BLiNCFw1ozYcFTCvuxoqVxg
https://mosaicbrandsltd.sharepoint.com/:f:/s/TechPack/EildJGkFIaRFtO2FlU2kla8BuZvHYz_sTLmN4_xpsN7xzw




$User = Read-Host -Prompt 'Please Enter Firstname.Lastname '
Get-ADUser -Identity $User -Properties * | Select-Object SamAccountName,Enabled,Department,LastLogonDate,PasswordExpired,PasswordLastSet,CannotChangePassword,BadLogonCount,BadPwdCount | Out-GridView

Get-ADUSer -Identity Luka.Softa -Properties * | Get-ADPrincipalGroupMembership | Select-Object Name | Out-GridView


# Get IP Address of Active Adapter
$ActiveAdapter = Test-NetConnection -ComputerName www.google.com | Select-Object -ExpandProperty InterfaceAlias
get-netipaddress | Where-Object {$_.InterfaceAlias -eq $ActiveAdapter} | Select-Object -ExpandProperty IPAddress