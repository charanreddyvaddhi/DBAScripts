/**BELOW QUERY IS USED TO FIND SESSIONS USING HIGH MEMORY**/
/**------------------------------------------------------**/
SELECT 
    SQLTEXT.TEXT,
    REQ.BLOCKING_SESSION_ID,
    SP.HOSTNAME,
    SP.CMD,
    SP.LASTWAITTYPE,
    SP.LAST_BATCH,
    REQ.SESSION_ID,
    REQ.STATUS,
    REQ.COMMAND,
    REQ.CPU_TIME,
    REQ.TOTAL_ELAPSED_TIME
FROM 
    SYS.SYSPROCESSES SP,SYS.DM_EXEC_REQUESTS REQ
        CROSS APPLY SYS.DM_EXEC_SQL_TEXT(SQL_HANDLE) AS SQLTEXT
WHERE 
    SP.SPID=REQ.SESSION_ID
