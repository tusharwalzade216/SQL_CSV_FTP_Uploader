
==================================== Use ======================================

This Powershell based Utility is useful to get SQL output as CSV file & upload it to FTP server. And sends an acknowledgement to the specified emails after each successful/ erroneous upload.

==================================== Files ======================================
1. gencsv.ps1 -> code to generate csv & upload to ftp
2. execps.bat -> command to execute gencsv.ps1 via PowerShell
3. query.sql  -> A SQL Query to get data
4. WinSCPnet.dll    -> Necessary Dependency
5. scheduleOnce.bat -> command to schedule task for given period
6. deleteTask.bat   -> Utility to delete this scheduled task

==================================== Pre-requisits =================================
- Windows
- PowerShell
- MSSQL Server
- A working FTP Server (eg. filezilla, for local)

==================================== Run ======================================
- Update the necessary paths & FTP, SMTP credentials/ details in files
- Run this file - `scheduleOnce.bat` as an Administrator.
    - It will schedule the task using windows task scheduler, so that it would run periodically.

==================================== Delete =====================================
- If you want to delete this scheduled task from scheduler, just run the file - `deleteTask.bat` as an Administrator.
