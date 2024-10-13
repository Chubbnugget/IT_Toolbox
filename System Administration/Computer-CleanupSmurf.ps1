###########################################################################################
# Disk Clean up script Version 3.0.1
# By Phil.Barrett
###########################################################################################
$Now = Get-Date -Format "dd-MM-yyyy-HHmm"
$TranscriptFile = "C:\Logs\DiskSmurf-" + $Now + ".log"
Start-Transcript -Force -NoClobber -IncludeInvocationHeader -Path $TranscriptFile 
############################################################################################
#Testing mode preference
############################################################################################
$WhatIfPreference = $false # Force -WhatIf for testing purposes. Set to $false for live usage.
if ($WhatIfPreference -eq $true) {
    Write-Host "Script in Testing Mode." -ForegroundColor Green
}
else {
    Write-Host "Script in Live Mode. All commands will process!" -ForegroundColor Red
}
############################################################################################
#Clear Bloat Appx Packages 
############################################################################################
Write-Host "Clearing Garbage Bloat Apps" -ForegroundColor Cyan
#List of Apps that we have decided are garbage
$TargetApps = @()
$ProTargetApps = @()
$TrashApps = @(
    '*Linkedin*',
    '*ClipChamp*',
    '*Netflix*',
    '*Disney*',
    '*Spotify*',
    '*Office*',
    'Microsoft.BingWeather*',
    'Microsoft.BingNews*',
    'Microsoft.Microsoft3DViewer*',
    'Microsoft.OfficeHub*',
    'Microsoft.MicrosoftSolitaireCollection*',
    'Microsoft.MixedReality.Portal*',
    'Microsoft.MicrosoftOfficeHub*',
    'Microsoft.People*',
    'Microsoft.SkypeApp*',
    '*Skype*'
    'Microsoft.Wallet*',
    'Microsoft.Office.OneNote*',
    'Microsoft.ZuneMusic*',
    'Microsoft.ZuneVideo*',
    'Microsoft.Xbox**',
    'Microsoft.WindowsSoundRecorder*',
    'Microsoft.WindowsMaps*',
    'Microsoft.WindowsFeedback*',
    '*.LenovoCompanion*',
    '*.HPDesktopSupportUtilities*',
    'Microsoft.MicrosoftStickyNotes*',
    'Microsoft.PowerAutomateDesktop*',
    'Microsoft.GamingApp*')

# Filter to Check for Trash Apps in Provisioned Packages
foreach ($TrashApp in $TrashApps) {
    $ProPackageFullName = (Get-AppxProvisionedPackage -online | Where-Object {$_.DisplayName -like $TrashApp}).PackageName

    if ($ProPackageFullName -like $TrashApp) {
        Write-Host "$ProPackageFullName Looks Like $TrashApp Adding to Provisioned Target List..." -ForegroundColor Red
        $ProTargetApps += $ProPackageFullName
        Write-Host
    }
    else {
        Write-Host "Unable to find Provisioned Package: $Trashapp" -ForegroundColor Cyan
    }
}
Write-Host "Targeting the following Provisioned Apps:"
Write-Host
Write-Host $ProTargetApps
Write-Host
Start-Sleep 5
#Same Filter Applied to Normal AppxPackages
foreach ($TrashApp in $TrashApps) {
    $AppPackageFullName = (Get-AppxPackage -AllUsers | Where-Object {$_.Name -like $TrashApp}).PackageFullName

    if ($AppPackageFullName -like $TrashApp) {
        Write-Host "$AppPackageFullName Looks Like $TrashApp Adding to Target List" -ForegroundColor Red
        $TargetApps += $AppPackageFullName
        Write-Host
    }
    else {
        Write-Host "Unable to find package: $Trashapp" -ForegroundColor Cyan
    }
}
Write-Host "Targeting the following Apps:"
Write-Host
Write-Host $TargetApps
Write-Host
Start-Sleep 5
# Now to remove apps previously found during the last two scans
foreach ($TargetApp in $TargetApps) {
    Write-Host "Trying to remove $TargetApp"
    Write-Host
    Get-AppxPackage -Name $TargetApp -AllUsers | Remove-AppxPackage -AllUsers -Verbose
}

Start-Sleep 5

Write-Host "Trying to remove $ProTargetApp"
foreach ($ProTargetApp in $ProTargetApps) {
    Write-Host "Removing App $ProTargetapp"
    Write-Host
    Remove-AppxProvisionedPackage -Online -Verbose -PackageName $ProTargetApp
}

############################################################################################
#Clearing Recylcing Bin
############################################################################################
Write-Host "Clearing Recycling Bin" -ForegroundColor Cyan
Clear-RecycleBin -Force

############################################################################################
#Clearing Windows Update Logs
############################################################################################
Write-Host Clearing Windows Update Logs -ForegroundColor Cyan
Stop-Service TrustedInstaller -Force
Start-Sleep 5
Write-Host "Deleting the following log files" -ForegroundColor Cyan
Get-ChildItem C:\Windows\Logs\CBS | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} | Write-Host
Get-ChildItem C:\Windows\Logs\CBS | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} | Remove-Item -Force
Write-Host "Completed..." -ForegroundColor Cyan

############################################################################################
# Clearing Hibernate File
############################################################################################
Write-Host "Disabling Hibernation & Clearing Hibernate File"
powercfg /hibernate off
Write-Host "Probably worked Moving on..."
Stop-Transcript
<#
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣠⠴⠖⠋⠉⠉⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠓⠶⠦⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠦⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠈⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠈⢳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠉⠳⠦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⢑⣶⣒⣖⣶⣭⣉⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣀⡴⠶⠖⠛⣍⠛⠉⠉⠉⠉⠉⠉⠉⠉⠛⠲⠶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⠀
⠀⠀⠀⠀⡼⠋⠀⠀⠀⢀⣴⢻⣁⠀⠀⡀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⠀⠀
⠀⠀⠀⢰⣃⡀⣀⣤⠖⠋⣿⣾⣏⣩⣿⣵⠾⡿⣷⣶⠴⠶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀
⠀⠀⣰⠟⠉⠉⠉⠻⣴⣴⣿⣿⣿⣏⣿⣧⠶⢛⣉⠉⡆⠀⢹⠛⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀
⠀⢰⠃⠀⠀⠀⠀⠀⠈⠿⣾⣿⡏⣿⠉⠀⠀⣾⣿⣆⡇⠀⠈⠀⠀⠙⢶⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀
⢸⢿⡇⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠸⣄⠀⠘⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠙⢶⣀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠀⠀
⠸⠾⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠹⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⡶⠶⠶⠶⠶⠤⣀⣸⠃⠀⠀
⠀⠀⢸⡷⢦⣄⣀⣀⣀⣀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠁⠀⠀⠀⠀⠀⠀⠈⠝⢦⡀⠀
⠀⠀⢸⡄⠀⠻⣍⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⢄⣀⡀⠀⠀⠀⠘⣷⡀
⠀⠀⠀⠻⣄⠀⠈⠳⣄⠀⠀⠀⠀⠀⣀⡶⠶⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⣿⢿⣿⡖⠙⡆⠀⠀⢠⡟⠁
⠀⠀⠀⠀⠈⠙⠲⠤⠬⣳⢦⣄⠀⠀⠉⠀⠀⠀⠙⣦⠀⠀⠀⠀⠀⠀⠀⠿⠃⢀⣶⠞⠁⠁⠰⠇⠀⢠⡞⠁⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠾⠛⠳⠶⢤⣀⣀⡈⠿⠀⣀⣠⣶⠶⠶⣤⡀⠀⠈⠁⠀⠀⠀⠀⢀⣴⠏⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⠞⠉⣈⡶⠚⠉⠓⠦⣀⣹⠏⠉⠛⠿⣀⠉⢷⠀⠀⠹⣤⣀⣀⣀⣠⠶⠖⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣾⡇⠀⣴⣏⠀⠀⠀⠀⠀⠈⠙⢧⠀⠀⠀⠉⣆⠈⣧⣀⡾⠙⡏⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠻⣄⠈⠉⠛⠦⣀⠀⠀⠀⠀⠈⠷⣄⣀⣠⢿⣤⠇⠀⠀⣼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⠶⠤⢤⡏⠶⣀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠀⢀⢾⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⠉⠶⣄⡀⠀⠀⠀⠀⢀⣠⠞⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀ ⠀⠀⠈⠉⠒⠲⠶⠚⠉⠀⠀⠀⠀⠀
#>