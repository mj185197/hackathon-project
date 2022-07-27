$query= "SELECT name as [Database Name],state_desc as [Status], recovery_model_desc as [Recovery_Model]  FROM sys.databases where state_desc != 'ONLINE'"

$server = $env:computername 
Import-Module SQLPS -DisableNameChecking

$instance=hostname
$queryoutput = Invoke-Sqlcmd -ServerInstance $instance -Database master -Query $query 


$output = $queryoutput | Out-String

if ($output.Length -ne 0)
{
    $t=' '
    foreach ($info in $output)
    {
        $t= $t +  $output
    }

$rawBody=@{text= '<!channel> *ERROR:* Databases *NOT ONLINE* on Batch Server ' + $server + ' '  + $t}

}
else
{
$rawBody=@{text= '<!channel> All Databases are *ONLINE* on Batch Server ' + $server + ' '  + $t + ': OK'}
}s


$uri = 'https://hooks.slack.com/services/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'
$contentType = 'application/json'
$jsonBody = (convertto-json $rawBody)


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -Uri $uri -Method POST -ContentType $contentType -Body $jsonBody



