--------------------------------------------------------
--  DDL for Procedure EMPLOYEE_SAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ODI_WS"."EMPLOYEE_SAL" (p_uniquebatchid IN VARCHAR2) AS
CURSOR cur_rev IS
SELECT
    uniqebatchid,
    salarydate,
    company,
    empid,
    basic,
    hra,
    medical,
    specialallow,
    otherallow,
    telephonerem,
    conveyance
FROM
    emp_stg_salary where uniqebatchid=p_uniquebatchid;
	BEGIN
	    FOR i IN cur_rev LOOP
		INSERT INTO emp_nom_salary( uniqebatchid,
    salarydate,
    company,
    empid,
    basic,
    hra,
    medical,
    specialallow,
    otherallow,
    telephonerem,
    conveyance)
	values(
	i.uniqebatchid,
    i.salarydate,
    i.company,
    i.empid,
    i.basic,
    i.hra,
    i.medical,
    i.specialallow,
    i.otherallow,
    i.telephonerem,
    i.conveyance);
        END LOOP;
EXCEPTION
WHEN no_data_found THEN
 raise_application_error(-20102, 'no_data_found' || 'Error!');
        RAISE;
		end;

/
