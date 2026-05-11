-----Package Specification 
create or replace PACKAGE LOG_COMMON_PKG
/*
||Filename:        LOG_COMMON_PKG.pks
||Description:     Package specification for reusable\common components 
||                 to be used across the application
||
|| *    Id       :        NA (re-usable components)
|| *    Author   :        Mohit Kumar Tyagi
|| *    Revision :        1.0
||
||Ver     Date            Author               Modification
||1.0     10-Aug-2025      Mohit Kumar Tyagi    Initial creation

||
*/
AS


    /*
   ========================================================================================================
   ||  Name   :  INSERT_DATABASE_LOG 
   ||  Purpose:  Autonomous procedure for logging purpose to insert into the 
   ||            database_log table
   ||  Sample Line to Call Block (to fetch value of input parameter and store
   ||  in database_log table)
   ||   LOG_COMMON_PKG.INSERT_DATABASE_LOG($$plsql_unit,$$plsql_line,'i_prog_name -> '|| i_prog_name,null);         
   ||            
   ||
   ||  Ver     Date              Author                     Modification
   ||  1.0     10-Aug-2025        Mohit Kumar Tyagi          Created
   ========================================================================================================
   */

    PROCEDURE INSERT_DATABASE_LOG 
   (
   i_prog_name   IN DATABASE_LOG.PROG_NAME%TYPE,
   i_prog_line   IN DATABASE_LOG.PROG_LINE%TYPE,
   i_Message     IN DATABASE_LOG.MESSAGE%TYPE, 
   i_lob_data    IN DATABASE_LOG.LOB_DATA%TYPE
   );

   /*
   =======================================================================================================
   ||  Name   :  INSERT_DATABASE_ERROR_LOG 
   ||  Purpose:  Autonomous procedure for error logging purpose to insert into the database_log table.
   ||            It will work in tandem with INSERT_DATABASE_LOG
   ||  Sample Line to Call Error logging Block (to Get the value of SQl error code, error Message and 
   ||  Line number where error has occurred)
   || LOG_COMMON_PKG.INSERT_DATABASE_ERROR_LOG($$plsql_unit,$$plsql_line,SQLCODE||'  '|| SQLERRM || ' '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||'  '|| DBMS_UTILITY.format_error_stack  ||' '|| substr(DBMS_UTILITY.format_call_stack,1,1500),null);
   ||            
   ||
   ||  Ver     Date              Author                     Modification
   ||  1.0     10-Aug-2025        Mohit Kumar Tyagi          Created
   =======================================================================================================
   */ 


   PROCEDURE INSERT_DATABASE_ERROR_LOG   
   (
   i_prog_name   IN DATABASE_LOG.PROG_NAME%TYPE,
   i_prog_line   IN DATABASE_LOG.PROG_LINE%TYPE,
   i_Message     IN DATABASE_LOG.MESSAGE%TYPE, 
   i_lob_data    IN DATABASE_LOG.LOB_DATA%TYPE
   );

   END LOG_COMMON_PKG;
--[END];

-----Package Body-------

create or replace PACKAGE BODY LOG_COMMON_PKG 
AS

PROCEDURE INSERT_DATABASE_LOG   
(
i_prog_name   IN DATABASE_LOG.PROG_NAME%TYPE,
i_prog_line   IN DATABASE_LOG.PROG_LINE%TYPE,
i_Message     IN DATABASE_LOG.MESSAGE%TYPE, 
i_lob_data    IN DATABASE_LOG.LOB_DATA%TYPE
)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
--l_dbName GLOBAL_NAME.GLOBAL_NAME%TYPE;
BEGIN



		INSERT INTO Database_Log
				(prog_name, prog_line,log_type,message, lob_data,created_on,os_user_name,
				CURRENT_EDITION_NAME,IP_ADDRESS
				)
		VALUES (i_prog_name, i_prog_line,'D', i_Message, i_lob_data,systimestamp,SYS_CONTEXT ('USERENV', 'OS_USER'),
		SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME'),SYS_CONTEXT('USERENV','IP_ADDRESS')
		);
		COMMIT;

	EXCEPTION
	WHEN OTHERS THEN
		NULL;
END INSERT_DATABASE_LOG;


/*
||Filename:        LOG_COMMON_PKG.pkb
||Description:     Insert Error log into Database 
*/
PROCEDURE INSERT_DATABASE_ERROR_LOG   
(
 i_prog_name   IN DATABASE_LOG.PROG_NAME%TYPE,
 i_prog_line   IN DATABASE_LOG.PROG_LINE%TYPE,
 i_Message     IN DATABASE_LOG.MESSAGE%TYPE, 
 i_lob_data    IN DATABASE_LOG.LOB_DATA%TYPE
 )
IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

		INSERT INTO Database_Log
			  (prog_name, prog_line,LOG_TYPE,Message, lob_data,CREATED_ON,os_user_name,
			  CURRENT_EDITION_NAME,IP_ADDRESS
			  )
		VALUES (i_prog_name, i_prog_line,'E', i_Message, i_lob_data,systimestamp,SYS_CONTEXT ('USERENV', 'OS_USER'),
		SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME'),SYS_CONTEXT('USERENV','IP_ADDRESS')
			  );
		COMMIT;


	EXCEPTION
	WHEN OTHERS
	THEN
		 NULL;
END INSERT_DATABASE_ERROR_LOG;
END LOG_COMMON_PKG;

--------Table script---------


  CREATE TABLE "SELECT_AI_USER"."DATABASE_LOG" 
   (	"LOG_ID" NUMBER(28,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"PROG_NAME" VARCHAR2(50 BYTE) COLLATE "USING_NLS_COMP", 
	"PROG_LINE" NUMBER(10,0), 
	"OS_USER_NAME" VARCHAR2(50 BYTE) COLLATE "USING_NLS_COMP", 
	"LOG_TYPE" CHAR(1 BYTE) COLLATE "USING_NLS_COMP", 
	"MESSAGE" VARCHAR2(2000 BYTE) COLLATE "USING_NLS_COMP", 
	"LOB_DATA" CLOB COLLATE "USING_NLS_COMP", 
	"CREATED_ON" TIMESTAMP (9) WITH TIME ZONE, 
	"CURRENT_EDITION_NAME" VARCHAR2(40 BYTE) COLLATE "USING_NLS_COMP", 
	"IP_ADDRESS" VARCHAR2(40 BYTE) COLLATE "USING_NLS_COMP", 
	 PRIMARY KEY ("LOG_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" 
 LOB ("LOB_DATA") STORE AS SECUREFILE (
  TABLESPACE "DATA" ENABLE STORAGE IN ROW 4000 CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

