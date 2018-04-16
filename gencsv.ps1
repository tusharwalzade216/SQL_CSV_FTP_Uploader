$basePath = "C:\SQL_CSV_FTP_Uploader\"
$uploadPath = "/Uploads/*"
$outFile = "C:\Windows\Temp\data_$(Get-Date -Format "yyyy-MM-dd").csv"
$query = Get-Content -Path $($basePath + "query.sql")
Invoke-Sqlcmd -ServerInstance XXX.XXX.XXX.XXX -Database YOURDB -Username BI_User -Password 'pass' -Query $query | Export-CSV $outFile -noType

$Username = "abcd@yahoo.in";
$Password = "";
function Send-ToEmail([string]$file, [string]$srvpath, [string]$status) {

    $message = new-object Net.Mail.MailMessage;
    $message.From = $Username;
    $message.To.Add("abcd@test.com");
    # $message.CC.Add("xyz@test.com");
    $message.IsBodyHtml = $TRUE;
    if ($status -eq $TRUE) {
        $message.Subject = "Backup Upload Sucessful - $($file)";
        $message.Body = "Your backup file - <b>$($file)</b> is successfully uploaded on location - <i>$($srvpath)</i>";
    }
    else {
        $message.Subject = "Backup Upload Error - $($file)";
        $message.Body = "Something went wrong while uploading your backup file - <b>$($file)</b> on location - <i>$($srvpath)</i>...!";        
    }

    $smtp = new-object Net.Mail.SmtpClient("smtp.mail.yahoo.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
}

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
    $session.PutFiles($outFile, $uploadPath).Check()
    Send-ToEmail -file $(Split-Path $outFile -leaf) -srvpath $($sessionOptions.HostName + $uploadPath) -status 'true'
}
catch {
    Send-ToEmail -file $(Split-Path $outFile -leaf) -srvpath $($sessionOptions.HostName + $uploadPath) -status 'false'
}
finally {
    $session.Dispose()
}
