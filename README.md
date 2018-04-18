
==================================== Use ======================================

- This Powershell based Utility is useful to get SQL outputs as CSV files & uploads them to FTP server.
- It generates a seperate csv file for each SQL query
- It sends an acknowledgement to the specified emails after each successful/ erroneous upload.
- After the process is completed, it writes the log to executions.log file

==================================== Files ======================================
1. gencsv.ps1 -> code to generate csv & upload to ftp
2. execps.bat -> command to execute gencsv.ps1 via PowerShell
3. query.sql  -> No. of SQL Queries Seperated by line
4. WinSCPnet.dll    -> Necessary Dependency
5. scheduleOnce.bat -> command to schedule task for given period
6. deleteTask.bat   -> Utility to delete this scheduled task
7. executions.log   -> A file to maintain execution logs. Initially this file may not be present.

==================================== Pre-requisits =================================
- Windows
- PowerShell
- MSSQL Server
- A working FTP Server (eg. filezilla, for local)

==================================== Run ======================================
- Download this project & keep all the files at this path - `C:\SQL_CSV_FTP_Uploader`
- Update the necessary paths & FTP, SMTP credentials/ details in files
- Run this file - `scheduleOnce.bat` as an Administrator.
    - It will schedule the task using windows task scheduler, so that it would run periodically.

==================================== Delete =====================================
- If you want to delete this scheduled task from scheduler, just run the file - `deleteTask.bat` as an Administrator.
