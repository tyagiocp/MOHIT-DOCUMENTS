create or replace PROCEDURE MY_DATA_PROCESSOR (
    i_prog_name IN VARCHAR2
) IS
    -- Local variables
    v_step_info   VARCHAR2(4000);
    v_error_stack VARCHAR2(4000);
BEGIN
    -- 1. INITIAL LOG
    -- We use TO_NUMBER for the line to ensure type compatibility
    v_step_info := 'Starting process for: ' || i_prog_name;

    LOG_COMMON_PKG.INSERT_DATABASE_LOG(
        $$plsql_unit, 
        TO_NUMBER($$plsql_line), 
        v_step_info, 
        NULL
    );

    -------------------------------------------------------
    -- START YOUR BUSINESS LOGIC HERE
    -------------------------------------------------------

    -- Example Logic:
    -- UPDATE my_table SET status = 'PROCESSED' WHERE name = i_prog_name;

    -------------------------------------------------------
    -- END YOUR BUSINESS LOGIC HERE
    -------------------------------------------------------

    -- 2. SUCCESS LOG
    LOG_COMMON_PKG.INSERT_DATABASE_LOG(
        $$plsql_unit, 
        TO_NUMBER($$plsql_line), 
        'Process completed successfully', 
        NULL
    );

EXCEPTION
    WHEN OTHERS THEN
        -- 3. ERROR LOG
        -- We concatenate the error details into one string as per your requirement
        v_error_stack := SQLCODE || ' | ' || SQLERRM || CHR(10) ||
                         'Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || CHR(10) ||
                         'Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK;

        LOG_COMMON_PKG.INSERT_DATABASE_ERROR_LOG(
            $$plsql_unit, 
            TO_NUMBER($$plsql_line), 
            SUBSTR(v_error_stack, 1, 4000), -- Ensure it doesn't exceed variable limits
            NULL
        );

        -- Crucial: Don't hide the error from the system
        RAISE;
END MY_DATA_PROCESSOR;
