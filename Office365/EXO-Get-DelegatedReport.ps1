Connect-ExchangeOnline -ShowBanner:$false

Write-Host "Getting all Mailboxes" -ForegroundColor Cyan
Write-Progress -Activity "Getting Mailbox Permissions" -Status "Processing Mailboxes" -PercentComplete 50
$mailboxes = Get-Mailbox -ResultSize unlimited | where{$_.RecipientTypeDetails -ne "DiscoveryMailbox"}

Write-Progress -Activity "Getting Mailbox Permissions" -Status "Processing Mailboxes" -PercentComplete 0
$UpperBound = $mailboxes.Count
$permissions = foreach ($mailbox in $mailboxes){  
    Get-MailboxPermission -Identity $mailbox.UserPrincipalName | where{$_.user -notlike "*self*"}
    $progress++
    $percentComplete = ($progress / $mailboxes.count) * 100
    Write-Progress -Activity "Getting Mailbox Permissions" -Status "Processing Mailboxes: $progress/$UpperBound" -PercentComplete $percentComplete    
}

Write-Progress -Activity "Getting Mailbox Permissions" -Status "Finished Processing Mailboxes" -PercentComplete 100

$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$permissions | Export-Csv -Path C:\Temp\MailboxDelegation-$Now.csv -NoTypeInformation
Write-Host "Exported Report to C:\Temp\MailboxDelegation-$Now.csv" -ForegroundColor Cyan