--To get the process list.
-----------------------------------------
SELECT * FROM SYS. SYSPROCESSES WHERE SPID>50 AND (LOWER(STATUS) = 'SLEEPING' OR LOWER(STATUS) = 'RUNNABLE' OR LOWER(STATUS) = 'BACKGROUND');

--To get the Hung Sessions in Databases.
-------------------------------------------
SELECT * FROM SYS.SYSPROCESSES WHERE CMD = 'KILLED/ROLLBACK' 

--To read the audit log file
-----------------------------------------
SELECT DISTINCT (ACTION_ID)  FROM SYS.FN_GET_AUDIT_FILE('filename with path', DEFAULT, DEFAULT)

--To remove or Drop database.
--------------------------------------------------------
USE MASTER
GO
ALTER DATABASE [DB_NAME] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE [DB_NAME]

--To remove Database from Always On Avalibility Group.(On Primary server run below)
------------------------------------------------------------------------------------------------------------------------------------------------
--On Primary server run below
ALTER AVAILABILITY GROUP <AOAG Group name> REMOVE DATABASE [DB_NAME]
GO

--Use the below to take backup of databases with default options
-----------------------------------------------------------------------------------------------------------
BACKUP DATABASE [DB_NAME] TO DISK = '\\PATH WHERE THE BACKUP NEED TO BE STORED\DB_NAME_DDMMYYYY_FULL.BAK'

--Use the below to know the status of query running
-----------------------------------------------------------------------------------
SELECT SESSION_ID, COMMAND, PERCENT_COMPLETE FROM SYS.DM_EXEC_REQUESTS WHERE SESSION_ID = <SESSION ID OF QUERY RUNNING>


#############
------TIPS------
#############

--Configuration management is not opening how to open
-----------------------------------------------------------------------------------------------
%programfiles(x86)%\Microsoft\Microsoft SQL Server\100\Shared folder
mofcomp "sqlmgmproviderxpsp2up.mof"


 	