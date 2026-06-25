use final_project;


# Data Cleaning #

---------------
-- Customers 
---------------

update customers 
set birthdate = str_to_date(birthdate , '%m/%d/%Y');

update customers
set acct_open_date = str_to_date(acct_open_date , '%m/%d/%Y');

alter table customers 
add column min_income int,
add column max_income int;

update customers 
set min_income = cast(replace(replace(trim(substring_index(yearly_income,"-",1)),"K",""),"$","") as unsigned) * 1000  
where yearly_income not like "%+%";

update customers
set min_income = 0 
where min_income is null;

update customers 
set max_income = cast(replace(replace(replace(trim(substring_index(yearly_income , "-" , -1)),"$",""),"K",""),"+","") as unsigned) *1000;

---------------
-- Products 
---------------

UPDATE products
SET recyclable  = '0' 
WHERE recyclable = '' ;

UPDATE products
SET low_fat  = '0' 
WHERE low_fat = '' ;

---------------
-- Returns 
---------------

update returns
set return_date = str_to_date(return_date ,'%m/%d/%Y');

---------------
-- sales2017 
---------------

update `sales 2017` 
set transaction_date = str_to_date(transaction_date , '%m/%d/%Y');

update `sales 2017` 
set stock_date = str_to_date(stock_date , '%m/%d/%Y');

---------------
-- sales2018 
---------------

update `sales 2018` 
set transaction_date = str_to_date(transaction_date , '%m/%d/%Y');

update `sales 2018` 
set stock_date = str_to_date(stock_date , '%m/%d/%Y');

-------------------------------------------------------------------------------

-----------------
#Table Creation#
-----------------

create view sales2017 as
select   s7.quantity ,s7.product_id ,round(s7.quantity * p.product_cost,2)as total_cost,round(s7.quantity * p.product_retail_price,2)as total_price,s7.customer_id,s7.transaction_date,s7.store_id
from products p
join `sales 2017` s7
on p.product_id = s7.product_id;


create view sales2018 as
select  s8.quantity ,s8.product_id ,ROUND(s8.quantity * p.product_cost, 2) AS total_cost,ROUND(s8.quantity * p.product_retail_price, 2) AS total_sales,s8.customer_id,s8.transaction_date,s8.store_id
from products p
join `sales 2018` s8
on p.product_id = s8.product_id;


create view sales as
select * from sales2017
union all
select * from sales2018;










