# SpToTempTable
## Stored Procedue (results) to temp table
SQL Server specific

### Problem
We can easily select individual colums from a table, view, or table function. We can also easily move the reults into a temporary table without first having to know the structure of the reuslts (via SELECT INTO).

But when the results are from a stored procedure this becomes more difficult. We can no longer select individual columns. And if we want to move it into a temp table then that table must be built "by hand" to exactly match the results of the procedure. In addition if a script does this and the procedure changes in the future it could cause the script to fail unexepcetdedly.

### Use
This tool is a procedure (SpToTempTable) that takes an arbitrary target EXEC statment and puts the results of that statement into a temp table.

A procedure can't really "return" a temp table. If a procedure creates a temp table, when that procedure finishes executing (returns) that temp table is gone becuase it only exists with the scopt of the procedure execution.

For this reason the user of this script needs to create a temp table before calling SpToTempTable. But the structure of that temp table is not important. It must have at least one column due to SQL Server requirement for tables. But the number of columns and their names does not matter. The SpToTempTable procedure will add all that column names from the target procedure result set and remove the columns that were intially in the temp table.

### Notes

SpToTempTable makes use of the buing in SQL Server procedure sp_describe_first_result_set that returns a result set descibing the the result set of target procedure in a way very similar to how sys.columns has defintons for a table (see structure below). 

SpToTempTable first executes this, then builds a dynamic SQL statememnt that: 

* Adds the target result set columns to the passed temp table
* Drops the original columns from the passed temp table
* Exceutes the target procedure with the result set going into the modified temp table


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
