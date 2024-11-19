SELECT TOP 10 
	QUERY_STATS.QUERY_HASH AS [QUERY HASH],   
    SUM(QUERY_STATS.TOTAL_WORKER_TIME) / SUM(QUERY_STATS.EXECUTION_COUNT) AS  [CPU TIME],  
    MIN(QUERY_STATS.STATEMENT_TEXT) AS [STATEMENT TEXT]  
FROM   
    (
		SELECT 
			QS.*,   
			SUBSTRING(ST.TEXT, (QS.STATEMENT_START_OFFSET/2) + 1,  
			((CASE STATEMENT_END_OFFSET   
					WHEN -1 THEN DATALENGTH(ST.TEXT)  
					ELSE QS.STATEMENT_END_OFFSET END  - QS.STATEMENT_START_OFFSET)/2) + 1) AS STATEMENT_TEXT  
		FROM 
			SYS.DM_EXEC_QUERY_STATS AS QS  
		CROSS APPLY 
			SYS.DM_EXEC_SQL_TEXT(QS.SQL_HANDLE) AS ST
	) AS QUERY_STATS  
GROUP BY 
	QUERY_STATS.QUERY_HASH  
ORDER BY 
	2 DESC;  