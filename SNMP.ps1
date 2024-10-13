cls
Get-Date
$SNMP = New-Object -ComObject olePrn.OleSNMP

for ($i=1; $i -le 254; $i++)

{ 

$IP = '172.20.11.' + $i 

$snmp.open($IP,'public',1,100) 

   try { 

       $HostName = '' 

       $HostName = $snmp.get('.1.3.6.1.2.1.1.1.0') 

       Write-Host $IP  "-" $HostName 

       } 

       catch{ 

           $snmp.close() 

           $error.clear() 

           }

}

Get-Date 