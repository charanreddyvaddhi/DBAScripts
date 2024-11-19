/**INDEX USAGE ON SPECIFIC DATABASE**/
USE [DATABASENAME]
GO
SELECT
	--OBJECTPROPERTY(S.[OBJECT_ID],'ISUSERTABLE'),
    OBJECT_NAME(S.[OBJECT_ID]) AS [TABLENAME],
    I.NAME AS [INDEXNAME],
    I.INDEX_ID,
    USER_SEEKS,
    USER_SCANS,
    USER_LOOKUPS,
    USER_UPDATES
FROM
    SYS.DM_DB_INDEX_USAGE_STATS AS S
        INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID
WHERE
    OBJECTPROPERTY(S.[OBJECT_ID],'ISUSERTABLE') = 1
	AND OBJECT_NAME(S.[OBJECT_ID]) NOT IN ('SPT_IDENTITY_ENTITLEMENT','SPT_SYSLOG_EVENT','SPT_CERTIFICATION_ITEM','SPT_ENTITLEMENT_SNAPSHOT')
	--AND (USER_SCANS+USER_SEEKS+USER_LOOKUPS)=0
ORDER BY
    USER_SEEKS DESC;