
$discSessions = $null
$discSessions = @(qwinsta /server:SVR-RDS01 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS01 $sessionID
    }
}

$discSessions = $null
$discSessions = @(qwinsta /server:SVR-RDS02 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS02 $sessionID
    }
}

$discSessions = $null
$discSessions = @(qwinsta /server:SVR-RDS03 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS03 $sessionID
    }
}

$discSessions = $null
$discSessions = @(qwinsta /server:SVR-RDS04 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS04 $sessionID
    }
}

$discSessions = $null
$discSessions = @(qwinsta /server:SVR-RDS05 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS05 $sessionID
    }
}

$discSessions = $null
$discSessions = @(qwinsta /server:SVR-RDS06 | Where-Object { $_ -match "Disc" } | ForEach-Object { ($_ -split "\s+")[2] })

foreach ($sessionID in $discSessions) {
    if ($sessionID -ne "0") {
        rwinsta /server:SVR-RDS06 $sessionID
    }
}






$ServerNames = "SVR-RDS01","SVR-RDS02","SVR-RDS03","SVR-RDS04","SVR-RDS05","SVR-RDS06"
foreach ($SeverName in $ServerNames) {
    $AllSessions += @(qwinsta /server:$ServerName)
    }
Write-Host $AllSessions

qwinsta