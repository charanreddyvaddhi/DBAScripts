/**MAX DOP CURRENT SETTINGS AND RECOMMENDED SETTINGS**/
/**-------------------------------------------------**/
SELECT 
    SOFT_NUMA, 
    CPU_PER_NUMA, 
    CURRENT_MAXDOP_VALUE = (SELECT VALUE FROM SYS.CONFIGURATIONS WHERE NAME = 'MAX DEGREE OF PARALLELISM'), 
    CORRECT_MAXDOP
        FROM (
            SELECT 
                DISTINCT COUNT(*) OVER() SOFT_NUMA, 
                COUNT(*) CPU_PER_NUMA,
                CASE 
                    WHEN COUNT(*) OVER() = 1 AND COUNT(*) <= 8 THEN 0
                    WHEN COUNT(*) OVER() = 1 AND COUNT(*) >= 8 THEN 8
                    WHEN COUNT(*) OVER() > 1 AND COUNT(*) <= 16 THEN COUNT(*)
                    WHEN COUNT(*) OVER() > 1 AND COUNT(*) >= 16 THEN CASE WHEN(CAST(COUNT(*) AS FLOAT) / 2) >= 16 THEN 16 ELSE (CAST(COUNT(*) AS FLOAT) / 2) END
                END CORRECT_MAXDOP
            FROM SYS.DM_OS_SCHEDULERS
            WHERE STATUS = 'VISIBLE ONLINE'
            GROUP BY PARENT_NODE_ID
            ) 
AS MAX_DOP_VAL

