--Provides information about SQL Server Availability Replicas and their replication states
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    rs.is_primary_replica AS IsPrimary, 
    rs.last_received_lsn,
    rs.last_hardened_lsn,
    rs.last_redone_lsn,
    rs.end_of_log_lsn,
    rs.last_commit_lsn
FROM
    sys.availability_replicas r 
INNER JOIN
    sys.dm_hadr_database_replica_states rs ON r.replica_id = rs.replica_id 
ORDER BY 
    IsPrimary DESC;
