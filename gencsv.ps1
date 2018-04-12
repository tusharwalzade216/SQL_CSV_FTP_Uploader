$basePath = "C:\SQL_CSV_FTP_Uploader\"
$outFile = "C:\Windows\Temp\sql_$(Get-Date -Format "yyyy-MM-dd").csv"
$query = Get-Content -Path $($basePath + "query.sql")
Invoke-Sqlcmd -ServerInstance 192.168.200.38 -Database ETL_Mappers -Username BI_USER -Password gsg@12345 -Query $query | Export-CSV $outFile -noType

# Load WinSCP .NET assembly
Add-Type -Path $($basePath + "WinSCPnet.dll")

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Ftp
    HostName = "localhost"
    PortNumber = 21
    UserName = "sakon"
    Password = "sakon@123"
}

$session = New-Object WinSCP.Session

try
{
    # Connect
    $session.Open($sessionOptions)

    # Transfer files
    $session.PutFiles($outFile, "/Uploads/*").Check()
}
finally
{
    $session.Dispose()
}
