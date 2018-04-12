REM Schedule can be - MINUTE, HOURLY, DAILY, WEEKLY, ONCE, ONSTART, ONLOGON, ONIDLE, MONTHLY, ONEVENT
schtasks /create /tn "SQL_CSV_FTP_Uploader" /tr C:\SQL_CSV_FTP_Uploader\execps.bat /sc minute /st 12:29:00 /ru System /rl highest
