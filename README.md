==================================== Use ======================================

This Powershell based Utility is useful to get SQL output as CSV file & upload it to FTP server. And sends an aknowledgement to the specified emails after an upload.

==================================== Files ======================================
1. gencsv.ps1 -> code to generate csv & upload to ftp
2. execps.bat -> command to execute gencsv.ps1 via PowerShell
3. query.sql  -> A SQL Query to get data
4. WinSCPnet.dll    -> Necessary Dependency
5. scheduleOnce.bat -> command to schedule task for given period

==================================== Pre-requisits =================================
- Windows
- PowerShell
- MSSQL Server
- A working FTP Server (eg. filezilla, for local)

==================================== Run ======================================
- Update the necessary paths & credentials in files
- Run this file - `scheduleOnce.bat` as an Administrator.
    - It will schedule the task using windows task scheduler, so that it would run periodically.
