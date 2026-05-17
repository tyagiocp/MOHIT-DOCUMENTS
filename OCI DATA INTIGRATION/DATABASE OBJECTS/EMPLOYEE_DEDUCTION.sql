--------------------------------------------------------
--  DDL for Procedure EMPLOYEE_DEDUCTION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ODI_WS"."EMPLOYEE_DEDUCTION" (p_uniquebatchid IN VARCHAR2) AS
CURSOR cur_rev IS
SELECT
    uniqebatchid,
    empid,
    loanb1,
    principal,
    interest,
    isstatus
FROM
    EMP_STG_DEDUCTIONS where uniqebatchid=p_uniquebatchid;
	BEGIN
	FOR i IN cur_rev LOOP
	INSERT INTO EMP_NOM_DEDUCTIONS(uniqebatchid,empid,loanb1,principal,interest,isstatus)
	values(i.uniqebatchid,i.empid,i.loanb1,i.principal,i.interest,i.isstatus);
END LOOP;
EXCEPTION
WHEN no_data_found THEN
 raise_application_error(-20102, 'no_data_found' || 'Error!');
        RAISE;
		end;

/
