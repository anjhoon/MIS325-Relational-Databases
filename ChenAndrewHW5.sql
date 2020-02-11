-- Andrew Chen
-- ac68644
-- MIS325 HW5

-- Q1
set serveroutput on;

declare
product_count number;

begin
    select count(*)
    into product_count
    from products;

    if product_count >= 7 then
        dbms_output.put_line('The number of products is greater than or equal 7.');
    else
        dbms_output.put_line('The number of products is less than 7.');
    end if;
end;

-- Q2
set serveroutput on;

declare
product_count number;
list_price_avg number(7,3);

begin
    select count(*),avg(list_price)
    into product_count, list_price_avg
    from products;
    
    if product_count >= 7 then
        dbms_output.put_line('Product count: ' || product_count);
        dbms_output.put_line('List price average: ' || list_price_avg);
    else
        dbms_output.put_line('The number of products is less than 7.');
    end if;
end;

-- Q3
set serveroutput on;

begin
    insert into categories values(1, 'Guitars');
    dbms_output.put_line('1 row was inserted.');
exception
    when dup_val_on_index then
        dbms_output.put_line('Row was not inserted - duplicate entry.');
end;

-- Q4

create or replace function test_glaccounts_description
(accnt_descript_param varchar2)
return number
is
descript_var number;
begin
    select 1
    into descript_var
    from general_ledger_accounts
    where account_description = accnt_descript_param;
    return descript_var;
exception
    when no_data_found then
        return 0;
end;

-- Q5
set serveroutput on;

begin
    if test_glaccounts_description('Book Inventory') = 1 then
        dbms_output.put_line('Account description is already in use.');
    else
        dbms_output.put_line('Account description is available.');
    end if;
end;