Connect-MsolService


$users = Get-MsolUser -All -EnabledFilter EnabledOnly | Where-Object { -not $_.StrongAuthenticationRequirements.Count -and $_.IsLicensed -eq $true }
                
$UsersArray = @()
                
    foreach ($user in $users) {
        $row = New-Object PSObject -Property @{
            Company = $Tenant
            User = $user.DisplayName
            Email = $user.UserPrincipalName
            MFA_Status = $user.StrongAuthenticationRequirements.State
            MFA_Methods = $user.StrongAuthenticationMethods.MethodType -join ", "
            Title = $user.Title
            Created = (Get-Date $user.WhenCreated).ToString("MM/dd/yyyy")
            }            
        $UsersArray += $row
        }
                
# Display the filtered user list
$UsersArray | Out-GridView

<#

$sa = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement

$sa.RelyingParty = "*"

$sa.State = "Enabled"

$sar = @($sa)

Set-MsolUser -UserPrincipalName $user -StrongAuthenticationRequirements $sar
(Get-MsolGroupMember -GroupObjectId "c2c7655c-92ee-40e3-a170-0a4b3a2ffc2a")
#>