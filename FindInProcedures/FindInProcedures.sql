SELECT
  so.name
, so.xtype
, sm.definition
, LEN(sm.definition)
, '|||' = '|||'
, *
FROM sys.sql_modules sm
LEFT OUTER JOIN sys.sysobjects so ON so.id = sm.object_id
WHERE definition LIKE '%???%'
