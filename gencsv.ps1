# process countdown start
$stopwatch = [system.diagnostics.stopwatch]::StartNew()

# logs the start time
$startTime = Get-Date

# base path where all necessary files are stored
$basePath = "C:\SQL_CSV_FTP_Uploader\"

# File upload path at FTP/ SFTP server
$uploadPath = "/*"

# Temporary path to store files temporarily
$tempPath = 'C:\Windows\Temp\'

# An array to store filenames to be generated using table names from queries
$outArr = @()

# reading queries from file
$queries = Get-Content -Path $($basePath + "query.sql")

# A file to write logs
$logFile = "$($basePath)executions.log"

# process status to write into log
$processStatus = "Success"

foreach ($query in $queries) {
    # Get query as a string so that table name can be extracted
    $q = [string]$query
    # Get table name from a query
    $res = ([regex]'(?is)\b(?:from|into|update)\s+(\[?.+\]?\.)?\[?(\[?\w+)\]?').Matches($q)
    $q1 = $res[0].GROUPS[2].Value
    # Generate a file name using table name
    $fileName = $($q1 + "_" + (Get-Date -Format "yyyy-MM-dd") + ".csv")
    # push a file name to an array so that it can be passed to upload all files sequentially
    $outArr += $fileName
    # Command to connect to a DB & take query backup as csv files on specified location
    Invoke-Sqlcmd -ServerInstance XXX.XXX.XXX.XXX -Database AdvocateDWH -Username BI_User -Password 'pass' -Query $query | Export-CSV $($tempPath + $fileName) -noType
}

# username for SMTP
$Username = "abcd@yahoo.in";
# password for SMTP
$Password = "12345678";

# function to send email on both success and error conditions
function Send-ToEmail([string]$files, [string]$srvpath, [string]$status) {

    $message = new-object Net.Mail.MailMessage;
    $message.From = $Username;
    $message.To.Add("abcd@test.com");
    # $message.CC.Add("xyz@test.com");
    $message.IsBodyHtml = $TRUE;
    if ($status -eq $TRUE) {
        $message.Subject = "Backup Upload Sucessful";
        $message.Body = "Your backup files - <b>$($files)</b> are successfully uploaded on location - <i>$($srvpath)</i>";
        $processStatus = "Success";
    } else {
        $message.Subject = "Backup Upload Error";
        $message.Body = "Something went wrong while uploading your backup files - <b>$($files)</b> on location - <i>$($srvpath)</i>...!";        
        $processStatus = "Failed";
    }

    $smtp = new-object Net.Mail.SmtpClient("smtp.mail.yahoo.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
}

# The code below for FTP/ SFTP can be generated using WinSCP for desktop
# Load WinSCP .NET assembly
Add-Type -Path $($basePath + "WinSCPnet.dll")

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol   = [WinSCP.Protocol]::Ftp
    HostName   = "localhost"
    PortNumber = 21
    UserName   = "sakon"
    Password   = "sakon@123"
}

$session = New-Object WinSCP.Session

try {
    # Connect
    $session.Open($sessionOptions)

    # Transfer files
    foreach ($outFile in $outArr) {
        $session.PutFiles($($tempPath + $outFile), $uploadPath).Check()
    }
    # send success email, passing files array as a string & server path
    Send-ToEmail -files $($outArr -join ", ") -srvpath $($sessionOptions.HostName + $uploadPath.TrimEnd('/*')) -status 'true'
}
catch {
    # send error email, passing files array as a string & server path
    Send-ToEmail -files $($outArr -join ", ") -srvpath $($sessionOptions.HostName + $uploadPath.TrimEnd('/*')) -status 'false'
}
finally {
    # closing the active session
    $session.Dispose()
    # removing the files that are temporarily stored during process
    foreach ($outFile in $outArr) {
        Get-Childitem $($tempPath + $outFile) | Remove-Item -Recurse -Force
    }
}

# process countdown end
$stopwatch.Stop()

# Write process log to the log file if process countdown is false/ stopped
if ($stopwatch.IsRunning -eq $FALSE) {
    Add-content -Path $logFile -Value "Execution Start Time: $($startTime)`n"
    Add-content -Path $logFile -Value "Execution End Time: $(Get-Date)`n"
    Add-content -Path $logFile -Value "Time Elapsed (in Minutes): $($stopwatch.Elapsed.TotalMinutes)`n"
    Add-content -Path $logFile -Value "Files Generated: $($outArr -join ", ")`n"
    Add-content -Path $logFile -Value "Process Status: $($processStatus)`n"
    Add-content -Path $logFile -Value "---------------------------------------------------------------"
    Add-content -Path $logFile -Value "`r`n"
}
