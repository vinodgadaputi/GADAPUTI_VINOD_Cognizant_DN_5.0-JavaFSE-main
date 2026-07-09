-- SCENARIO 1: PROCESS MONTHLY INTEREST FOR SAVINGS ACCOUNTS
-- This procedure adds 1% interest to all savings accounts

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
AS
    -- Cursor to get all savings accounts that are active
    CURSOR savings_accounts IS
        SELECT account_id, balance, account_type
        FROM accounts
        WHERE account_type = 'SAVINGS'
        AND status = 'ACTIVE';
    
    -- Variable to store interest rate (1%)
    v_interest_rate DECIMAL(5, 4) := 0.01;
    -- Variable to store new balance after adding interest
    v_new_balance DECIMAL(12, 2);
    -- Variable to store how much interest is earned
    v_interest_earned DECIMAL(12, 2);
    -- Counter to count how many accounts we processed
    v_total_accounts NUMBER := 0;
    -- Variable to store total interest earned from all accounts
    v_total_interest DECIMAL(12, 2) := 0;
BEGIN
    -- Print header
    DBMS_OUTPUT.PUT_LINE('=== MONTHLY INTEREST PROCESSING ===');
    DBMS_OUTPUT.PUT_LINE('Process Started: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('Interest Rate: ' || (v_interest_rate * 100) || '%');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    
    -- Loop through each account in the cursor
    FOR account_rec IN savings_accounts LOOP
        -- Calculate interest (balance * 0.01)
        v_interest_earned := account_rec.balance * v_interest_rate;
        -- Calculate new balance (old balance + interest)
        v_new_balance := account_rec.balance + v_interest_earned;
        
        -- Update the account with new balance
        UPDATE accounts
        SET balance = v_new_balance,
            last_interest_date = SYSDATE
        WHERE account_id = account_rec.account_id;
        
        -- Save record of interest in log table
        INSERT INTO interest_log (account_id, interest_amount, interest_date, old_balance, new_balance)
        VALUES (account_rec.account_id, v_interest_earned, SYSDATE, account_rec.balance, v_new_balance);
        
        -- Add 1 to counter
        v_total_accounts := v_total_accounts + 1;
        -- Add interest earned to total
        v_total_interest := v_total_interest + v_interest_earned;
        
        -- Print details of this account
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || account_rec.account_id || 
                           ' | Interest Earned: $' || ROUND(v_interest_earned, 2) ||
                           ' | New Balance: $' || ROUND(v_new_balance, 2));
    END LOOP;
    
    -- Save all changes to database
    COMMIT;
    
    -- Print summary
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Accounts Processed: ' || v_total_accounts);
    DBMS_OUTPUT.PUT_LINE('Total Interest Earned: $' || ROUND(v_total_interest, 2));
    DBMS_OUTPUT.PUT_LINE('Process Completed Successfully');
    
-- If there is any error, undo everything
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END ProcessMonthlyInterest;
/


-- SCENARIO 2: UPDATE EMPLOYEE BONUS BASED ON PERFORMANCE
-- This procedure adds bonus to employee salary based on department and bonus percentage

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    -- Input parameter: which department to give bonus
    p_department_id IN NUMBER,
    -- Input parameter: what percentage bonus to give (like 5 for 5%)
    p_bonus_percentage IN DECIMAL
)
AS
    -- Cursor to get all active employees in the given department
    CURSOR emp_cursor IS
        SELECT employee_id, salary, department_id
        FROM employees
        WHERE department_id = p_department_id
        AND status = 'ACTIVE';
    
    -- Variable to store bonus amount (salary * bonus%)
    v_bonus_amount DECIMAL(12, 2);
    -- Variable to store new salary after bonus
    v_new_salary DECIMAL(12, 2);
    -- Variable to store total bonus given to all employees
    v_total_bonus DECIMAL(12, 2) := 0;
    -- Counter for how many employees got bonus
    v_emp_count NUMBER := 0;
    -- Variable to store department name
    v_dept_name VARCHAR2(100);
BEGIN
    -- Check if bonus percentage is valid (0-100)
    IF p_bonus_percentage < 0 OR p_bonus_percentage > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid bonus percentage. Must be between 0 and 100.');
    END IF;
    
    -- Check if department ID is provided
    IF p_department_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Department ID cannot be NULL.');
    END IF;
    
    -- Get the department name from database
    SELECT department_name INTO v_dept_name
    FROM departments
    WHERE department_id = p_department_id;
    
    -- Print header
    DBMS_OUTPUT.PUT_LINE('=== EMPLOYEE BONUS UPDATE ===');
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
    DBMS_OUTPUT.PUT_LINE('Bonus Percentage: ' || p_bonus_percentage || '%');
    DBMS_OUTPUT.PUT_LINE('Process Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    
    -- Loop through each employee in this department
    FOR emp_rec IN emp_cursor LOOP
        -- Calculate bonus amount (salary * bonus% / 100)
        v_bonus_amount := emp_rec.salary * (p_bonus_percentage / 100);
        -- Calculate new salary (old salary + bonus)
        v_new_salary := emp_rec.salary + v_bonus_amount;
        
        -- Update employee salary and bonus in database
        UPDATE employees
        SET salary = v_new_salary,
            bonus_amount = v_bonus_amount,
            last_bonus_date = SYSDATE
        WHERE employee_id = emp_rec.employee_id;
        
        -- Save record of this bonus in history table
        INSERT INTO bonus_history (employee_id, bonus_percentage, bonus_amount, old_salary, new_salary, bonus_date)
        VALUES (emp_rec.employee_id, p_bonus_percentage, v_bonus_amount, emp_rec.salary, v_new_salary, SYSDATE);
        
        -- Add 1 to employee counter
        v_emp_count := v_emp_count + 1;
        -- Add bonus to total bonus given
        v_total_bonus := v_total_bonus + v_bonus_amount;
        
        -- Print details of this employee
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_rec.employee_id || 
                           ' | Bonus: $' || ROUND(v_bonus_amount, 2) ||
                           ' | New Salary: $' || ROUND(v_new_salary, 2));
    END LOOP;
    
    -- Save all changes
    COMMIT;
    
    -- Print summary
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Employees Updated: ' || v_emp_count);
    DBMS_OUTPUT.PUT_LINE('Total Bonus Distributed: $' || ROUND(v_total_bonus, 2));
    DBMS_OUTPUT.PUT_LINE('Update Completed Successfully');
    
-- If department not found
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Department ID ' || p_department_id || ' not found.');
        RAISE;
    -- If any other error
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END UpdateEmployeeBonus;
/


-- SCENARIO 3: TRANSFER FUNDS BETWEEN ACCOUNTS
-- This procedure transfers money from one account to another
-- It checks if there is enough money before transferring

CREATE OR REPLACE PROCEDURE TransferFunds(
    -- Input parameter: account to send money FROM
    p_source_account_id IN NUMBER,
    -- Input parameter: account to send money TO
    p_target_account_id IN NUMBER,
    -- Input parameter: how much money to transfer
    p_transfer_amount IN DECIMAL
)
AS
    -- Variable to store balance of source account
    v_source_balance DECIMAL(12, 2);
    -- Variable to store balance of target account
    v_target_balance DECIMAL(12, 2);
    -- Variable to store status of source account (ACTIVE or not)
    v_source_status VARCHAR2(20);
    -- Variable to store status of target account
    v_target_status VARCHAR2(20);
    -- Variable to check if source account exists
    v_source_exists NUMBER;
    -- Variable to check if target account exists
    v_target_exists NUMBER;
BEGIN
    -- Check if transfer amount is greater than 0
    IF p_transfer_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Transfer amount must be greater than 0.');
    END IF;
    
    -- Check if source and target account are different
    IF p_source_account_id = p_target_account_id THEN
        RAISE_APPLICATION_ERROR(-20004, 'Source and target accounts cannot be the same.');
    END IF;
    
    -- Check if source account exists in database
    SELECT COUNT(*) INTO v_source_exists
    FROM accounts
    WHERE account_id = p_source_account_id;
    
    IF v_source_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Source account does not exist.');
    END IF;
    
    -- Check if target account exists in database
    SELECT COUNT(*) INTO v_target_exists
    FROM accounts
    WHERE account_id = p_target_account_id;
    
    IF v_target_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Target account does not exist.');
    END IF;
    
    -- Get balance and status of source account
    SELECT balance, status INTO v_source_balance, v_source_status
    FROM accounts
    WHERE account_id = p_source_account_id
    FOR UPDATE;
    
    -- Check if source account is active
    IF v_source_status != 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20007, 'Source account is not active.');
    END IF;
    
    -- Check if source account has enough money
    IF v_source_balance < p_transfer_amount THEN
        RAISE_APPLICATION_ERROR(-20008, 'Insufficient balance. Available: $' || v_source_balance || 
                               ', Requested: $' || p_transfer_amount);
    END IF;
    
    -- Get balance and status of target account
    SELECT balance, status INTO v_target_balance, v_target_status
    FROM accounts
    WHERE account_id = p_target_account_id
    FOR UPDATE;
    
    -- Check if target account is active
    IF v_target_status != 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20009, 'Target account is not active.');
    END IF;
    
    -- Subtract money from source account
    UPDATE accounts
    SET balance = balance - p_transfer_amount,
        last_transaction_date = SYSDATE
    WHERE account_id = p_source_account_id;
    
    -- Add money to target account
    UPDATE accounts
    SET balance = balance + p_transfer_amount,
        last_transaction_date = SYSDATE
    WHERE account_id = p_target_account_id;
    
    -- Save record of this transaction
    INSERT INTO transactions (source_account_id, target_account_id, transfer_amount, transaction_date, transaction_type)
    VALUES (p_source_account_id, p_target_account_id, p_transfer_amount, SYSDATE, 'TRANSFER');
    
    -- Save all changes to database
    COMMIT;
    
    -- Print success message
    DBMS_OUTPUT.PUT_LINE('=== FUND TRANSFER SUCCESSFUL ===');
    DBMS_OUTPUT.PUT_LINE('From Account ID: ' || p_source_account_id);
    DBMS_OUTPUT.PUT_LINE('To Account ID: ' || p_target_account_id);
    DBMS_OUTPUT.PUT_LINE('Transfer Amount: $' || ROUND(p_transfer_amount, 2));
    DBMS_OUTPUT.PUT_LINE('Source New Balance: $' || ROUND(v_source_balance - p_transfer_amount, 2));
    DBMS_OUTPUT.PUT_LINE('Target New Balance: $' || ROUND(v_target_balance + p_transfer_amount, 2));
    DBMS_OUTPUT.PUT_LINE('Transaction Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('================================');
    
-- If anything goes wrong, undo everything and show error
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('TRANSFER FAILED: ' || SQLERRM);
        RAISE;
END TransferFunds;
/


-- First, turn on output so we can see results
SET SERVEROUTPUT ON;

-- Run Procedure 1: Process monthly interest for all savings accounts
EXEC ProcessMonthlyInterest;

-- Run Procedure 2: Give 5% bonus to employees in department 10
EXEC UpdateEmployeeBonus(10, 5);

-- Run Procedure 3: Transfer $500 from account 1001 to account 1002
EXEC TransferFunds(1001, 1002, 500);