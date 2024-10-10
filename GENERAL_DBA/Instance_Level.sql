--To get the up time/startup time of any SQL server
----------------------------------------------------------------------------------
SELECT @@SERVERNAME, SQLSERVER_START_TIME FROM SYS.DM_OS_SYS_INFO

--To remove or Drop database
-------------------------------------------------
USE MASTER;
GO
ALTER DATABASE <DB_NAME> SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE <DB_NAME>;

--To get the list of all user databases
----------------------------------------------------------
SELECT NAME FROM SYS.DATABASES WHERE DATABASE_ID > 4 AND GROUP_DATABASE_ID IS NULL

--To set the databases Offline from online we use this
------------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET OFFLINE WITH ROLLBACK IMMEDIATE

--To Get the list of Logins and associated roles to it at server level
---------------------------------------------------------------------------------------------------------
SELECT R.NAME AS ROLE, M.NAME AS PRINCIPAL FROM 
MASTER.SYS. SERVER_ROLE_MEMBERS AS RM 
INNER JOIN  MASTER.SYS. SERVER_PRINCIPALS R ON R. PRINCIPAL_ID = RM. ROLE_PRINCIPAL_ID AND 
R. TYPE = 'R' 
INNER JOIN MASTER.SYS. SERVER_PRINCIPALS M ON M. PRINCIPAL_ID = RM. MEMBER_PRINCIPAL_ID 
ORDER BY M.NAME 

--To Extract the associated logins and its permissions in a database
--------------------------------------------------------------------------------------------------------------
USE [DB_NAME]
GO
SELECT
[LOGIN TYPE] =
CASE SP. TYPE
WHEN 'U' THEN 'DOMAIN_ACCOUNT'
WHEN 'S' THEN 'LOCAL_ACCOUNT'
WHEN 'G' THEN 'GROUP_ACCOUNT'
END,
CONVERT (CHAR (50), SP.NAME) AS SERVER_LOGIN,
CONVERT (CHAR (50), SP2.NAME) AS SERVER_ROLE,
CONVERT (CHAR (50), DBP.NAME) AS DATABASE_USER,
CONVERT (CHAR (50), DBP2.NAME) AS DATABASE_ROLE
FROM
SYS. SERVER_PRINCIPALS AS SP JOIN
SYS. DATABASE_PRINCIPALS AS DBP ON SP.SID=DBP.SID JOIN
SYS. DATABASE_ROLE_MEMBERS AS DBRM ON DBP. PRINCIPAL_ID=DBRM.MEMBER_PRINCIPAL_ID
JOIN
SYS. DATABASE_PRINCIPALS AS DBP2 ON DBRM. ROLE_PRINCIPAL_ID=DBP2.PRINCIPAL_ID LEFT JOIN
SYS. SERVER_ROLE_MEMBERS AS SRM ON SP. PRINCIPAL_ID=SRM. MEMBER_PRINCIPAL_ID LEFT JOIN
SYS. SERVER_PRINCIPALS AS SP2 ON SRM. ROLE_PRINCIPAL_ID=SP2.PRINCIPAL_ID