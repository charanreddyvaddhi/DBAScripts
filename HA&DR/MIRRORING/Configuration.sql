Prerequisites
---------------------
	-->Mirroring requires SQL Server Enterprise or Standard editions. The Witness can run on SQL Server Express.
	-->The database must use the FULL recovery model.
	-->A full backup and a transaction log backup of the principal database are required before you can set up mirroring.
	-->Database mirroring communication between the Principal and Mirror servers happens over TCP endpoints.
	
##############################################################

-- On Principal Server make the database to full recovery mode
------------------------------------------------------------------------------------------------------
USE [MASTER]
GO
ALTER DATABASE [DB_NAME] SET RECOVERY FULL;
GO

--Take a full and tlog backup on principal server and restore on mirror server with NORECOVERY
--Make sure the database is in restoring state on mirror database
 
 
 -- On Principal Server, Mirror Server and witness server
----------------------------------------------------------------------------------------
CREATE ENDPOINT [Mirroring_Endpoint] 
    STATE = STARTED
    AS TCP (LISTENER_PORT = 5022)
    FOR DATABASE_MIRRORING (ROLE = <ALL | WITNESS>, ENCRYPTION = REQUIRED ALGORITHM AES);
GO

--Grant connect privilages on services accounts
------------------------------------------------------------------------------
-- On Principal Server
GRANT CONNECT ON ENDPOINT::[Mirroring_Endpoint] TO [DOMAIN\MirrorServerLogin];
GRANT CONNECT ON ENDPOINT::[Mirroring_Endpoint] TO [DOMAIN\WitnessServerLogin];
GO

-- On Mirror Server
GRANT CONNECT ON ENDPOINT::[Mirroring_Endpoint] TO [DOMAIN\PrincipalServerLogin];
GRANT CONNECT ON ENDPOINT::[Mirroring_Endpoint] TO [DOMAIN\WitnessServerLogin];
GO

-- On Witness Server (Optional)
GRANT CONNECT ON ENDPOINT::[Mirroring_Endpoint] TO [DOMAIN\PrincipalServerLogin];
GRANT CONNECT ON ENDPOINT::[Mirroring_Endpoint] TO [DOMAIN\MirrorServerLogin];
GO

--Configuraing database Mirroring
-------------------------------------------------------
-- On Principal Server
USE [MASTER]
GO
ALTER DATABASE [DB_NAME] SET PARTNER = N'TCP://MirrorServerInstance:5022';
GO

-- On Mirror Server
USE [MASTER]
GO
ALTER DATABASE [DB_NAME] SET PARTNER = N'TCP://PrincipalServerInstance:5022';
GO

-- On Principal Server(Optional)
USE [MASTER]
GO
ALTER DATABASE [DB_NAME]  SET WITNESS = N'TCP://WitnessServerInstance:5022';
GO


##############################################################


-- Check mirroring status
----------------------------------------
SELECT 
    DATABASE_ID, MIRRORING_STATE_DESC,  MIRRORING_ROLE_DESC, MIRRORING_SAFETY_LEVEL_DESC, MIRRORING_FAILOVER_LSN
FROM SYS.DATABASE_MIRRORING
WHERE DATABASE_ID = DB_ID('DB_NAME');

