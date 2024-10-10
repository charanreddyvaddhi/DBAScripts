SELECT 
	TYPE, 
	SUM(PAGES_KB) AS KB,
	SUM(PAGES_KB)/1024 AS MB 
FROM SYS.DM_OS_MEMORY_CLERKS 
GROUP BY TYPE ORDER BY SUM(PAGES_KB) DESC