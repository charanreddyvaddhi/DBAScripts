--Command to check the integrity of a database
----------------------------------------------------------------------------------
DBCC CHECKDB ('DATABASE_NAME') WITH NO_INFOMSGS, ALL_ERRORMSGS, DATA_PURITY

--Command to check the integrity of a Table or indexed view 
-------------------------------------------------------------------------------------------------
DBCC CHECKTABLE ('TABLE_NAME');

--To Get the Query running in that session
------------------------------------------------------------------
DBCC INPUTBUFFER(SESSION_ID)

--To Check Open transaction
---------------------------------------------------
DBCC OPENTRAN('DATABASE_NAME')

--To Check the log file size and percent of used in one click
-----------------------------------------------------------------------------------------------
DBCC SQLPERF(LOGSPACE)

--To get the details about the fragmentation of data and indexes for a table
---------------------------------------------------------------------------------------------------------------------------
USE [DB_NAME]
GO
DBCC SHOWCONTIG ('TABLENAME');

--Removes all clean buffers from the buffer pool
------------------------------------------------------------------------------
DBCC DROPCLEANBUFFERS;

--Reduces the size of a data file or log file.
-------------------------------------------------------------------
DBCC SHRINKFILE ('LOGICAL_FILE_NAME');

--Shrinks the size of a Database 
---------------------------------------------------
DBCC SHRINKDATABASE ('DatabaseName');

--To enable/disbale/check status of a Trace 
-----------------------------------------------------------------------
DBCC TRACEON (TraceFlag);
DBCC TRACEOFF (TraceFlag);
DBCC TRACESTATUS (TraceFlag);

--Rebuilds indexes for a table.
-------------------------------------------------
DBCC DBREINDEX ('TableName');
DBCC REINDEX ('TableName', 'IndexName', FillFactor);

--Returns information from the transaction log.
--------------------------------------------------------------------------
DBCC LOG('DatabaseName', 0|1|2|3);


--Command to repair database if corrupted with data loss
------------------------------------------------------------------------------------------------
DBCC CHECKDB (TESTDB, REPAIR_ALLOW_DATA_LOSS | REPAIR_REBUILD | REPAIR_FAST) WITH NO_INFOMSGS;
/* Perform the Above Operation only after setting the database in single user mode, once repair is done change into multi user mode. */
USE MASTER;
GO
ALTER DATABASE DB_NAME SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DBCC CHECKDB (DB_NAME, REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS;
GO
ALTER DATABASE DB_NAME SET MULTI_USER;