SELECT 
    COUNT(*) AS NUMBER_OF_SESSIONS, 
    DB_NAME(RESOURCE_DATABASE_ID) AS DATABASE_NAME 
FROM SYS.DM_TRAN_LOCKS
WHERE 
    RESOURCE_TYPE = 'DATABASE' 
        AND RESOURCE_DATABASE_ID NOT IN (1,2,3,4,32767) 
        AND REQUEST_TYPE = 'LOCK' 
        AND REQUEST_STATUS = 'GRANT'
GROUP BY RESOURCE_DATABASE_ID 
