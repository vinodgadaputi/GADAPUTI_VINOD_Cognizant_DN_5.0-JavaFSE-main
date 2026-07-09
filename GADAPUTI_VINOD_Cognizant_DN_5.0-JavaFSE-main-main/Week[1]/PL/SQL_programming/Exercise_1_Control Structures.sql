-- SCENARIO 1: DISCOUNT FOR CUSTOMERS ABOVE 60 YEARS OLD
DECLARE
    CURSOR customer_cursor IS
        SELECT customer_id, age, loan_id, interest_rate
        FROM customers c
        JOIN loans l ON c.customer_id = l.customer_id
        WHERE age > 60;
    
    v_discount DECIMAL(5, 2) := 0.01;
    v_new_rate DECIMAL(5, 4);
    v_updated_count NUMBER := 0;
BEGIN
    FOR customer_rec IN customer_cursor LOOP
        v_new_rate := customer_rec.interest_rate * (1 - v_discount);
        
        UPDATE loans
        SET interest_rate = v_new_rate
        WHERE loan_id = customer_rec.loan_id;
        
        v_updated_count := v_updated_count + 1;
        
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_rec.customer_id || 
                           ' | Old Rate: ' || customer_rec.interest_rate || 
                           '% | New Rate: ' || v_new_rate || '%');
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Total loans updated: ' || v_updated_count);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- SCENARIO 2: PROMOTE CUSTOMERS TO VIP STATUS
DECLARE
    CURSOR vip_cursor IS
        SELECT customer_id, balance
        FROM customers
        WHERE balance > 10000;
    
    v_vip_count NUMBER := 0;
BEGIN
    FOR customer_rec IN vip_cursor LOOP
        UPDATE customers
        SET is_vip = TRUE,
            vip_promotion_date = SYSDATE
        WHERE customer_id = customer_rec.customer_id;
        
        v_vip_count := v_vip_count + 1;
        
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_rec.customer_id || 
                           ' promoted to VIP | Balance: $' || customer_rec.balance);
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Total VIP promotions: ' || v_vip_count);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- SCENARIO 3: SEND REMINDERS FOR LOANS DUE IN 30 DAYS
DECLARE
    CURSOR due_loans_cursor IS
        SELECT c.customer_id, 
               c.customer_name, 
               c.email,
               l.loan_id, 
               l.due_date,
               l.loan_amount
        FROM customers c
        JOIN loans l ON c.customer_id = l.customer_id
        WHERE l.due_date BETWEEN SYSDATE AND SYSDATE + 30
        AND l.status = 'ACTIVE'
        ORDER BY l.due_date;
    
    v_reminder_count NUMBER := 0;
    v_days_remaining NUMBER;
BEGIN
    FOR loan_rec IN due_loans_cursor LOOP
        v_days_remaining := TRUNC(loan_rec.due_date - SYSDATE);
        
        DBMS_OUTPUT.PUT_LINE('==================================');
        DBMS_OUTPUT.PUT_LINE('LOAN PAYMENT REMINDER');
        DBMS_OUTPUT.PUT_LINE('==================================');
        DBMS_OUTPUT.PUT_LINE('Customer Name: ' || loan_rec.customer_name);
        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || loan_rec.loan_id);
        DBMS_OUTPUT.PUT_LINE('Loan Amount: $' || loan_rec.loan_amount);
        DBMS_OUTPUT.PUT_LINE('Due Date: ' || TO_CHAR(loan_rec.due_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Days Remaining: ' || v_days_remaining);
        DBMS_OUTPUT.PUT_LINE('Email: ' || loan_rec.email);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
        
        INSERT INTO reminder_log (customer_id, loan_id, reminder_date, reminder_type)
        VALUES (loan_rec.customer_id, loan_rec.loan_id, SYSDATE, 'PAYMENT_DUE');
        
        v_reminder_count := v_reminder_count + 1;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Total reminders sent: ' || v_reminder_count);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/