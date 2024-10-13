Connect-ExchangeOnline -ShowBanner:$false

$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$InactiveDate = ((Get-Date).AddDays(-30))

Write-Host "Getting all Mailboxes" -ForegroundColor Cyan
Write-Progress -Activity "Getting Mailbox Permissions" -Status "Processing Mailboxes" -PercentComplete 50
$mailboxes = Get-Mailbox -ResultSize unlimited | Where-Object{$_.RecipientTypeDetails -ne "DiscoveryMailbox"}

Write-Progress -Activity "Getting Mailbox Permissions" -Status "Processing Mailboxes" -PercentComplete 0
$UpperBound = $mailboxes.Count
$Statistics = foreach ($mailbox in $mailboxes){  
    Get-EXOMailboxStatistics -Identity $mailbox.UserPrincipalName -Properties LastLogonTime | Where-Object{$_.LastLogonTime -le $InactiveDate}
    $progress++
    $percentComplete = ($progress / $mailboxes.count) * 100
    Write-Progress -Activity "Getting Mailbox Statistics" -Status "Processing Mailboxes: $progress/$UpperBound" -PercentComplete $percentComplete    
}

Write-Progress -Activity "Getting Mailbox Statistics" -Status "Finished Processing Mailboxes" -PercentComplete 100


$Statistics | Export-Csv -Path C:\Temp\MailboxInactivity-$Now.csv -NoTypeInformation
Write-Host "Exported Report to C:\Temp\MailboxInactivity-$Now.csv" -ForegroundColor Cyan
