--To get the list of process running and what are they is given using below
-----------------------------------------------------------------------------------------------------------------------
SELECT SPID, DB_NAME (DBID) AS DB_NAME, HOSTNAME, LOGINAME, LAST_BATCH, PROGRAM_NAME FROM SYS. SYSPROCESSES WHERE PROGRAM_NAME <> ' ';
(Or)
SELECT * FROM SYS. SYSPROCESSES WHERE SPID>50 AND (LOWER(STATUS) = 'SLEEPING' OR LOWER(STATUS) = 'RUNNABLE' OR LOWER(STATUS) = 'BACKGROUND');

--For user session/process details
---------------------------------------------------
SELECT SPID, HOSTNAME, LOGINAME, DB_NAME(DBID) AS DB_NAME, STATUS FROM SYS. SYSPROCESSES
WHERE SPID>50 AND DB_NAME(DBID) NOT IN ('MASTER', 'MODEL', 'MSDB')
/* as spid<50 is internal system process*/

--To Kill the deadlock session
----------------------------------------------
USE [MASTER]
GO
DECLARE @KILL VARCHAR(MAX) = '';
SELECT @KILL = @KILL + 'KILL ' + CONVERT (VARCHAR (10), SPID) + '; '
FROM MASTER..SYSPROCESSES
WHERE SPID > 50 AND DBID = DB_ID('<YOUR_DB_NAME>')
EXEC(@KILL);
GO
SET DEADLOCK_PRIORITY HIGH
ALTER DATABASE [DB_NAME] SET MULTI_USER WITH NO_WAIT
ALTER DATABASE [DB_NAME] SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO

--To check any hung session if any
------------------------------------------------------
SELECT @@SERVERNAME AS SERVER
GO
SELECT CMD, SPID, KPID, LOGIN_TIME, STATUS, HOSTNAME, NT_USERNAME, LOGINAME, HOSTPROCESS, CPU, MEMUSAGE, PHYSICAL_IO
FROM SYS. SYSPROCESSES
WHERE CMD = 'KILLED/ROLLBACK';
(Or)
SELECT * FROM SYS. SYSPROCESSES
WHERE CMD = 'KILLED/ROLLBACK' OR BLOCKED <> 0

--To Check the execution percentage of a session we use below.
--------------------------------------------------------------------------------------------------------
SELECT PERCENT_COMPLETE FROM SYS.DM_EXEC_REQUESTS
WHERE SESSION_ID=<SESSION ID>

--To check the transaction locks on the database
--------------------------------------------------------------------------------
SELECT * FROM SYS.DM_TRAN_LOCKS WHERE DB_NAME(RESOURCE_DATABASE_ID) = 'DB_NAME' 

####
--Info
####
--PAG: 11:3:8 -- which means as below
		11 is database id
		3 is file id
		8 is page id