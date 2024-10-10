--Create Database endpoints on both the servers 
--------------------------------------------------------------------------------
-- On NODE1
CREATE ENDPOINT [END_POINT_NAME] STATE=STARTED
    AS TCP (LISTENER_PORT = 5022) FOR DATABASE_MIRRORING (ROLE=ALL);
-- On NODE2
CREATE ENDPOINT [END_POINT_NAME] STATE=STARTED
    AS TCP (LISTENER_PORT = 5022) FOR DATABASE_MIRRORING (ROLE=ALL);



-- Create the Availability Group from any of Servers 
----------------------------------------------------------------------------------
USE [MASTER]
GO
CREATE AVAILABILITY GROUP [AVAILABILITY_GROUP_NAME]
    FOR DATABASE [DB_NAME]
    REPLICA ON 
        N'SQLINSTANCENAME1' WITH (ENDPOINT_URL = N'TCP://SQLINSTANCENAME1:5022', 
            FAILOVER_MODE = AUTOMATIC,
            SESSION_TIMEOUT = 10),
        N'SQLINSTANCENAME2' WITH (ENDPOINT_URL = N'TCP://SQLINSTANCENAME2:5022', 
            FAILOVER_MODE = AUTOMATIC,
            SESSION_TIMEOUT = 10)
    WITH (DB_FAILOVER = ON);
	
	USE [TestDB];

-- Join the database to the Availability Group Run below on primary instance
-----------------------------------------------------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET HADR AVAILABILITY GROUP = [AVAILABILITY_GROUP_NAME];

--Enable data movement for the replicas
-------------------------------------------------------------------
ALTER AVAILABILITY GROUP [AVAILABILITY_GROUP_NAME] 
    MODIFY REPLICA ON N'SQLINSTANCENAME1' 
    WITH (SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL));

ALTER AVAILABILITY GROUP [AVAILABILITY_GROUP_NAME] 
    MODIFY REPLICA ON N'SQLINSTANCENAME2' 
    WITH (SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL));

--Backup database from SQLINSTANCENAME1 and restore into SQLINSTANCENAME2 

--Join the secondary replica to  availability group
-------------------------------------------------------------------------------
-- On SQLServer2
ALTER AVAILABILITY GROUP [AVAILABILITY_GROUP_NAME] JOIN;


--To check the status of AOAG GROUP
------------------------------------------------------------- 
SELECT * FROM sys.dm_hadr_availability_group_states;


















--To remove databases from AOAG (run on primary instance)
-------------------------------------------------------------------------------------------------
ALTER AVAILABILITY GROUP <AOAG_GROUP_NAME>
REMOVE DATABASE [DB_NAME]
