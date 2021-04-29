DROP PROCEDURE #SpToTempTable
GO
​
CREATE PROCEDURE #SpToTempTable
  @ProcStm NVARCHAR(MAX), @TableName VARCHAR(128)
​
AS
BEGIN
​
DROP TABLE IF EXISTS #Struct
CREATE TABLE #Struct
( is_hidden                     BIT             NOT NULL
, column_ordinal                INT             NOT NULL
, name                          SYSNAME         NULL
, is_nullable                   BIT             NOT NULL
, system_type_id                INT             NOT NULL
, system_type_name              NVARCHAR(256)   NULL
, max_length                    SMALLINT        NOT NULL
, precision                     TINYINT         NOT NULL
, scale                         TINYINT         NOT NULL
, collation_name                SYSNAME         NULL
, user_type_id                  INT             NULL
, user_type_database            SYSNAME         NULL
, user_type_schema              SYSNAME         NULL
, user_type_name                SYSNAME         NULL
, assembly_qualified_type_name  NVARCHAR(4000)  NULL
, xml_collection_id             INT             NULL
, xml_collection_database       SYSNAME         NULL
, xml_collection_schema         SYSNAME         NULL
, xml_collection_name           SYSNAME         NULL
, is_xml_document               BIT             NOT NULL
, is_case_sensitive             BIT             NOT NULL
, is_fixed_length_clr_type      BIT             NOT NULL
, source_server                 SYSNAME         NULL
, source_database               SYSNAME         NULL
, source_schema                 SYSNAME         NULL
, source_table                  SYSNAME         NULL
, source_column                 SYSNAME         NULL
, is_identity_column            BIT             NULL
, is_part_of_unique_key         BIT             NULL
, is_updateable                 BIT             NULL
, is_computed_column            BIT             NULL
, is_sparse_column_set          BIT             NULL
, ordinal_in_order_by_list      SMALLINT        NULL
, order_by_list_length          SMALLINT        NULL
, order_by_is_descending        SMALLINT        NULL
, tds_type_id                   INT             NOT NULL
, tds_length                    INT             NOT NULL
, tds_collation_id              INT             NULL
, tds_collation_sort_id         TINYINT         NULL
);
​
INSERT #Struct EXEC sp_describe_first_result_set @ProcStm;
​
DECLARE @DropColList VARCHAR(MAX) = ''
SELECT @DropColList = @DropColList + ',' + sc.name FROM tempdb.sys.columns sc WHERE sc.object_id = OBJECT_ID(N'tempdb..' +@TableName)
SELECT @DropColList = STUFF(@DropColList,1,1,'')
DECLARE @DropStm VARCHAR(MAX) = 'ALTER TABLE ' + @TableName + ' DROP COLUMN ' + @DropColList + ';'
​
DECLARE @Stm VARCHAR(MAX) = '';
SELECT @Stm = @Stm + 'ALTER TABLE ' + @TableName + ' ADD ' + QUOTENAME (name) + ' ' + system_type_name + '; ' FROM #Struct
SELECT @Stm = @Stm + @DropStm
SELECT @Stm = @Stm + 'INSERT ' + @TableName + ' ' + @ProcStm + '; '
--SELECT @Stm
EXEC (@Stm)
​
END
GO
​
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
​
DROP TABLE IF EXISTS #DOut
CREATE TABLE #DOut (ColToDel1 INT, ColToDel2 int)
​
EXEC #SpToTempTable N'EXEC someprocedure someparms;', N'#DOut'
​
SELECT * FROM #DOut
​
