--To Operate pair in high performance mode – Async
-------------------------------------------------------------------------------------
-->connect to principal server and execute
ALTER DATABASE [DB_NAME] SET PARTNER SAFETY OFF

--To Operate pair in high safety mode – Sync
----------------------------------------------------------------------
-->connect to principal server and execute
ALTER DATABASE [DB_NAME] SET PARTNER SAFETY FULL

###############################################
--Run below on principal databases based on requirement
###############################################
--To disconnect the mirroring use the below
----------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET PARTNER SAFETY OFF

--#To change the database mode from Async to sync
------------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET PARTNER SAFETY FULL

#To change the database mode from sync to Async
----------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET PARTNER OFF

--#To pause the mirroring between database use below
-----------------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET PARTNER SUSPEND

--#To Resume the mirroring between databases, use below
-----------------------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET PARTNER RESUME

--#To failover the databases from principal to mirror use below
------------------------------------------------------------------------------------------------------
ALTER DATABASE [DB_NAME] SET PARTNER FAILOVER

--Run the below query to know the endpoint details
------------------------------------------------------------------------------------
SELECT * FROM SYS.DATABASE_MIRRORING_ENDPOINTS

--#To Start or stop the endpoints of mirror in SQL Server
-----------------------------------------------------------------------------------------
ALTER ENDPOINT '<EndPointName>' STATE=STOPPED -- To stop the endpoint.
GO
ALTER ENDPOINT '<EndPointName>' STATE=STARTED -- To start the endpoint
GO

###############################################
--Run below on Mirror databases based on requirement
###############################################
--#To pause the mirroring between database use below
----------------------------------------------------------------------------------------------
ALTER DATABASE <DATABASE NAME> SET PARTNER SUSPEND

--#To Resume the mirroring between databases, use below
-----------------------------------------------------------------------------------------------
ALTER DATABASE <DATABASE NAME> SET PARTNER RESUME

--#To failover the databases from principal to mirror use below – manual failover
-----------------------------------------------------------------------------------------------------------------------------------
ALTER DATABASE <DATABASE NAME> SET PARTNER FAILOVER # only when principal is down

--#To failover the databases from principal to mirror use below – forcible failover
---------------------------------------------------------------------------------------------------------------------------------
ALTER DATABASE <DATABASE NAME> SET PARTNER FORCE_SERVICE_ALLOW_DATA_LOSS

--#To switch the mirroring off use below
---------------------------------------------------------------
ALTER DATABASE <DATABASE NAME> SET WITNESS OFF

--#When the database is in restoring to bring it online use below
-------------------------------------------------------------------------------------------------------
RESTORE DATABASE <DATABASE NAME> WITH RECOVERY 



--Run the below query to get the mirroring details	and status
-------------------------------------------------------------------------------------------------
SELECT 
	DB_NAME(DATABASE_ID) AS DB_NAME, MIRRORING_STATE_DESC, MIRRORING_ROLE_DESC,
	MIRRORING_PARTNER_NAME, MIRRORING_PARTNER_INSTANCE, *
FROM SYS.DATABASE_MIRRORING