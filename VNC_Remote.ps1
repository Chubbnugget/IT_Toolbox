###############################################################################
# VNC Connection tool
# This script will trigger Tight VNC to launch and connect using details provided
###############################################################################
# Changelog:
# v1.1 - Resolved bug with hostname If Statement
# v1.2 - Improved switch to handle differnt inputs
# v1.3 - Added k for Katies
# v1.4 - Added Hostname 3 and 4 to handle MACK stores named with "_"
# v1.5 - Resolved issue setting hostname 3 and 4
# v2.0 - Updated to use UltraVNC Client
# V2.1 - Planned addition : Use UltraVNC Encryption plugin
###############################################################################

clear-Host
while ($true) {
    Clear-Host
    Write-Host "                                          Store Connection Tool v2.0" -ForegroundColor Red
#Accept inputs from user
    $StoreCode = Read-Host -Prompt 'Please Enter Store Code (4 Digit Number) : '
    Write-Host "Please input one of the following brands : NoniB, Rockmans, Wlane, Millers, Autograph, Katies, Rivers"
    $Brand = Read-Host -Prompt 'Please Enter Store Brand : ' 
    $Till = Read-Host -Prompt 'Please Enter Till Number Eg. 1 or 2 : ' 
#Convert random inputs into lowercase and then set BrandCode 
    Switch ($Brand.ToLower()) {
        "rockmans" { $BrandCode="RK" }
        "rk" { $BrandCode="RK" }
        "rock" { $BrandCode="RK" }
        "wlane" { $BrandCode="WL" }
        "wl" { $BrandCode="WL" }
        "lane" { $BrandCode="WL" }
        "w" { $BrandCode="WL" }
        "nonib" { $BrandCode="NB" }
        "noni" { $BrandCode="NB" }
        "n" { $BrandCode="NB" }
        "nb" { $BrandCode="NB" }
        "millers" { $BrandCode="M" }
        "ml" { $BrandCode="M" }
        "m" { $BrandCode="M" }
        "miller" { $BrandCode="M" }
        "autograph" { $BrandCode="A" }
        "ag" { $BrandCode="A" }
        "auto" { $BrandCode="A" }
        "a" { $BrandCode="A" }
        "katies" { $BrandCode="K" }
        "kt" { $BrandCode="K" }
        "k" { $BrandCode="K" }
        "katie" { $BrandCode="K" }
        "rivers" { $BrandCode="RV" }
        "rv" { $BrandCode="RV" }
        "river" { $BrandCode="RV" }
        "riv" { $BrandCode="RV" }
        Default {$BrandCode="Error"}
    }
#Error Handle for bad Brand input
    If ($BrandCode -eq "Error") {
         write-host -ForegroundColor Red "Error Reading Brand..."
         $BrandLoc= Read-Host -Prompt " Try again?(Y/N)"
         if ($BrandLoc -eq "y") { 
             continue
         } else {  
             break
         }
    }
# Check Brand code and set password
switch ($BrandCode) {
    "M" {$Password="div555"}
    "A" {$Password="div555"}
    "K" {$Password="div555"}
    "RV" {$Password="div555"}
    "RK" {$Password="m@xaphone"}
    "WL" {$Password="m@xaphone"}
    "NB" {$Password="m@xaphone"}
    Default {$Password="div555"}
}
#Set hostname structure based on brand
switch ($BrandCode) {
    "M" {$HostName1 = "$StoreCode-$BrandCode-0$Till.internal.retail"; $HostName2 = "$StoreCode-$BrandCode-0$Till.pgfg.prettygirl.com.au"; $HostName3 = $StoreCode + "_" + $BrandCode + "_" + "0" + $Till + ".internal.retail"; $Hostname4 = $StoreCode + "_" + $BrandCode + "_" + "0" + $Till + ".pgfg.prettygirl.com.au"}
    "A" {$HostName1 = "$StoreCode-$BrandCode-0$Till.internal.retail"; $HostName2 = "$StoreCode-$BrandCode-0$Till.pgfg.prettygirl.com.au"; $HostName3 = $StoreCode + "_" + $BrandCode + "_" + "0" + $Till + ".internal.retail"; $Hostname4 = $StoreCode + "_" + $BrandCode + "_" + "0" + $Till + ".pgfg.prettygirl.com.au"}
    "K" {$HostName1 = "$StoreCode-$BrandCode-0$Till.internal.retail"; $HostName2 = "$StoreCode-$BrandCode-0$Till.pgfg.prettygirl.com.au"; $HostName3 = $StoreCode + "_" + $BrandCode + "_" + "0" + $Till + ".internal.retail"; $Hostname4 = $StoreCode + "_" + $BrandCode + "_" + "0" + $Till + ".pgfg.prettygirl.com.au"}
    "RV" {$HostName1 = "$BrandCode-$StoreCode-POS$Till.internal.retail"; $Hostname2 = "$BrandCode-$StoreCode-POS$Till.pgfg.prettygirl.com.au"}
    "RK" {$HostName1 = "$BrandCode-$StoreCode-POS$Till.internal.retail"; $HostName2 = "$BrandCode-$StoreCode-POS$Till.pgfg.prettygirl.com.au"}
    "WL" {$HostName1 = "$BrandCode-$StoreCode-POS$Till.internal.retail"; $HostName2 = "$BrandCode-$StoreCode-POS$Till.pgfg.prettygirl.com.au"}
    "NB" {$HostName1 = "$BrandCode-$StoreCode-POS$Till.internal.retail"; $Hostname2 = "$BrandCode-$StoreCode-POS$Till.pgfg.prettygirl.com.au"}
    Default {}
}

    # Begin attempts to resolve DNS and then connect... If it fails output connection settings for troubleshooting
    Write-Host "Testing Connection to Store..."
    if(resolve-dnsname -name $HostName1 ) {Start-Process -FilePath "C:\Program Files\ultravnc\winvnc.exe" -ArgumentList -connect="$HostName1", -password="$Password"} 
        Elseif (Resolve-DnsName -name $HostName2) {Start-Process -FilePath "C:\Program Files\ultravnc\winvnc.exe" -ArgumentList -connect="$HostName2", -password="$Password"}
        Elseif (Resolve-DnsName -name $HostName3) {Start-Process -FilePath "C:\Program Files\ultravnc\winvnc.exe" -ArgumentList -connect="$HostName3", -password="$Password"} 
        Elseif (Resolve-DnsName -name $HostName4) {Start-Process -FilePath "C:\Program Files\ultravnc\winvnc.exe" -ArgumentList -connect="$HostName4", -password="$Password"} 
            else {
                Clear-Host
                Write-Host "[Error] Could not establish connection" -ForegroundColor Red
                Write-Host "Please share this error with I.T" -ForegroundColor Red
                Write-Host
                Write-Host "Connection Failed using :`n
                Host 1 : $Hostname1
                Host 2 : $Hostname2 
                Host 3 : $Hostname3
                Host 4 : $Hostname4
                PSK : $Password
                Brand : $Brandcode
                Store Code : $StoreCode"
                Write-Host ""
    }

    break
}
Read-Host -Prompt "Press the any key to exit"
exit
# Fin
