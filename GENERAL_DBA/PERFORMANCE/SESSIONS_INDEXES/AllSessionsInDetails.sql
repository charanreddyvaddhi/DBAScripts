/**ALL SESSIONS ALONG WITH ITS DETAILS**/
/**-----------------------------------**/
SELECT DISTINCT
    P.SESSION_ID, 
    CASE 
        WHEN P.STATUS = 'SUSPENDED' AND R.BLOCKING_SESSION_ID > 0 THEN 1 
        WHEN P.STATUS = 'SUSPENDED' AND R.BLOCKING_SESSION_ID = 0 THEN 2 
        WHEN P.STATUS = 'RUNNABLE' THEN 3
        WHEN P.STATUS = 'RUNNING' THEN 4
        WHEN P.STATUS = 'SLEEPING' AND P.OPEN_TRANSACTION_COUNT = 1 THEN 9 
        WHEN P.STATUS = 'SLEEPING' AND P.OPEN_TRANSACTION_COUNT = 0 THEN 10 
        ELSE 5 
    END AS FLAG_STATUS
    ,P.OPEN_TRANSACTION_COUNT  
    ,R.PERCENT_COMPLETE 
    ,DB_NAME(P.DATABASE_ID) AS DB_NAME
    ,P.LOGIN_NAME
    ,P.STATUS 
    ,R.LAST_WAIT_TYPE 
    ,R.BLOCKING_SESSION_ID
    ,DATEDIFF(SECOND, R.START_TIME, GETDATE()) AS DURATION 
    ,R.START_TIME 
    ,R.COMMAND
    ,P.CPU_TIME
    ,S.TEXT 
    ,SUBSTRING(S.TEXT, (R.STATEMENT_START_OFFSET / 2) + 1, ((R.STATEMENT_END_OFFSET / 2) - (R.STATEMENT_START_OFFSET / 2)) + 2) AS SQL_TEXT
    ,R.WAIT_TIME 
    ,C.CLIENT_NET_ADDRESS 
    ,P.HOST_NAME 
    ,PROGRAM_NAME
    --,CAST(PAN.QUERY_PLAN AS XML) QUERY_PLAN 
FROM SYS.DM_EXEC_SESSIONS P
LEFT OUTER JOIN SYS.DM_EXEC_CONNECTIONS C 
    ON P.SESSION_ID = C.SESSION_ID
LEFT OUTER JOIN SYS.DM_EXEC_REQUESTS R
    ON P.SESSION_ID = R.SESSION_ID
CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) S
LEFT OUTER JOIN (
    SELECT R.SESSION_ID, CONVERT(NVARCHAR(MAX), P.QUERY_PLAN) AS QUERY_PLAN 
    FROM SYS.DM_EXEC_REQUESTS R 
    CROSS APPLY SYS.DM_EXEC_QUERY_PLAN(R.PLAN_HANDLE) P
) PAN ON R.SESSION_ID = PAN.SESSION_ID
--WHERE P.SESSION_ID != @@SPID
ORDER BY FLAG_STATUS, R.BLOCKING_SESSION_ID DESC, P.CPU_TIME DESC, R.LAST_WAIT_TYPE;

