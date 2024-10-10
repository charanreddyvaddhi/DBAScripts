--To get the list of Objects.
------------------------------------------
EXEC SP_HELP

--Execute this line to check the connection with instances from centralized server for health checks.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC SP_HELPDB OR SP_HELPDB ‘<DB_NAME>’

--To Get the logins details.
------------------------------------------
EXEC SP_HELPLOGINS

--To get the list of connections.
-------------------------------------------------
EXEC SP_WHO or EXEC SP_WHO2

--Execute this line to get the transfer login script  in the instance.
------------------------------------------------------------------------------------------------------
EXEC SP_HELP_REVLOGIN

--Execute to below to know the members in a group login
----------------------------------------------------------------------------------------------
EXEC XP_LOGININFO 'GROUP\LOGIN’, ‘MEMBERS'
/* Give Input as Group login name name*/

--To remove databases from replication.
----------------------------------------------------------------
EXEC SP_REMOVEDBREPLICATION '<DB_NAME>'

--To read the SQL server and SQL agent Error Logs use the below.
------------------------------------------------------------------------------------------------------- 
EXEC SP_READERRORLOG <LOG_NUMBER>, <LOG_TYPE>, <SEARCH_TERM1>, <SEARCH_TERM2>, <START_DATE>, <END_DATE>, <SORT_ORDER>;
--(Or)
EXEC XP_READERRORLOG <LOG_NUMBER>, <LOG_TYPE>, <SEARCH_TERM1>, <SEARCH_TERM2>, <START_DATE>, <END_DATE>, <SORT_ORDER>;
/*
<lognumber>: 0-current log file, 1-next logfile archives...
<logtype>: 1: Error log, 2: Agent error log
N'', --These are filters
N'', --These are filters
N'2022-07-19', -- start date to sort
N'2022-07-20', --end date to sort
N'asc' -- sort order desc and asc(default)
Examples:
sp_readerrorlog 0,1 for current error logs;
sp_readerrorlog 1,1 for archived logs
*/

--To Extract the orphan users (report option) and used to fix them
--------------------------------------------------------------------------------------------------------
USE [DB_NAME]
GO
EXEC SP_CHANGE_USERS_LOGIN 'REPORT’ --FOR EXTRACTING ORPHAN USERS;
EXEC  SP_CHANGE_USERS_LOGIN 'UPDATE_ONE', ‘<LOGIN NAME>’, '<USER NAME>’ –-FOR FIXING THE ORPHAN USERS.
EXEC SP_CHANGE_USERS_LOGIN 'AUTOFIX','<USER NAME>'

