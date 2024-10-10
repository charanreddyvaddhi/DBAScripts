--To get the row count of all tables present in a database
---------------------------------------------------------------------------------------------
SELECT 
	SCHEMA_NAME (SCHEMA_ID) AS [SCHEMA_NAME],
	[TABLES].NAME AS [TABLENAME],
	SUM([PARTITIONS].[ROWS]) AS [TOTALROWCOUNT]
FROM SYS.TABLES AS [TABLES] JOIN SYS.PARTITIONS AS [PARTITIONS]
	ON [TABLES].[OBJECT_ID] = [PARTITIONS].[OBJECT_ID] AND [PARTITIONS].INDEX_ID IN ( 0, 1 ) 
--WHERE [TABLES].NAME = N'NAME OF THE TABLE'
GROUP BY 
	SCHEMA_NAME(SCHEMA_ID), [TABLES].NAME;

--To get the Logical, Physical Files name and locations along with database and type of file
----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	D.NAME DATABASENAME, F.NAME LOGICALNAME, F. PHYSICAL_NAME AS PHYSICALNAME, F. TYPE_DESC TYPEOFFILE 
FROM 
	SYS. MASTER_FILES F 
INNER JOIN SYS. DATABASES D ON D. DATABASE_ID = F. DATABASE_ID 

--To get the sum of all list of files we use the below
---------------------------------------------------------------------------------
SELECT 
	'SERVERNAME' = @@SERVERNAME,
	'TOTAL SIZE IN MEGABYTES'= CONVERT (DECIMAL (10,2), (SUM (SIZE * 8.00) / 1024.00)),
	'TOTAL SIZE IN GIGABYTES' = CONVERT (DECIMAL (10,2), (SUM (SIZE * 8.00) / 1024.00 / 1024.00)),
	'TOTAL SIZE IN TERABYTES' = CONVERT (DECIMAL (10,2),(SUM (SIZE * 8.00) / 1024.00 / 1024.00 /1024.00))
FROM 
	SYS. MASTER_FILES

--To get teh individal database size by sum of files 
---------------------------------------------------------------------------------
SELECT 
	DATABASE_NAME = D.NAME, USEDSPACE_MB = ((SUM(MF.SIZE)*8)/1024) 
FROM SYS.MASTER_FILES MF JOIN SYS.DATABASES D ON MF.DATABASE_ID=D.DATABASE_ID
WHERE 
	MF.TYPE_DESC='ROWS' 
GROUP BY D.NAME 
ORDER BY USEDSPACE_MB DESC

--To get the fragmentation of a database 
------------------------------------------------------------------
USE [DB_NAME]
GO
SELECT 
	OBJECT_NAME(OBJECT_ID), 
	INDEX_ID, INDEX_TYPE_DESC, INDEX_LEVEL, 
	AVG_FRAGMENTATION_IN_PERCENT, AVG_PAGE_SPACE_USED_IN_PERCENT, PAGE_COUNT 
FROM 
	SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'DB_NAME'), NULL, NULL, NULL, 'SAMPLED')
ORDER BY 
	AVG_FRAGMENTATION_IN_PERCENT DESC