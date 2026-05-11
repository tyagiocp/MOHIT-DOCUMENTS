-----Package Specification 
create or replace PACKAGE my_async_package AS
        PROCEDURE long_running_procedure (p_input_param IN VARCHAR2);
        PROCEDURE start_async_long_running (p_input_param IN VARCHAR2);
    END my_async_package;
-----Package Body-------

create or replace PACKAGE BODY my_async_package AS
        PROCEDURE long_running_procedure (p_input_param IN VARCHAR2) IS
        BEGIN
          DBMS_LOCK.SLEEP(10);
            DBMS_OUTPUT.PUT_LINE('Long running procedure executed with param: ' || p_input_param);
        END long_running_procedure;

        PROCEDURE start_async_long_running (p_input_param IN VARCHAR2) IS
            l_job_name VARCHAR2(128);
        BEGIN
            l_job_name := 'ASYNC_JOB_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF');

            DBMS_SCHEDULER.CREATE_JOB (
                job_name        => l_job_name,
                job_type        => 'PLSQL_BLOCK',
                job_action      => 'BEGIN my_async_package.long_running_procedure(''' || p_input_param || '''); END;',
                start_date      => SYSTIMESTAMP,
                enabled         => TRUE,
                auto_drop       => TRUE, -- Job automatically drops after completion
                comments        => 'Asynchronous call to long_running_procedure'
            );
            DBMS_OUTPUT.PUT_LINE('Asynchronous job ' || l_job_name || ' submitted.');
        END start_async_long_running;
    END my_async_package;