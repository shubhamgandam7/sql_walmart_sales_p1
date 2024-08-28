create database project_p2;

drop table if exists walmart_sales;
create table walmart_sales
(
	Invoice int  Primary key,
	Branch char(5),
	City varchar(25),
	Customer_type varchar(25),
	Gender	varchar(10),
	Product_line varchar(25),
	Unit_price float,
	Quantity int,
	Tax	float,
	Total	float,
	sale_date	date,
	sale_day varchar(10),
	sale_time time,
	Payment	varchar(15),
	cogs	float,
	gross_margin_percentage float,
	gross_income float,
	Rating float);

select * from walmart_sales

select 
count(*)
from walmart_sales;

select
count(distinct Invoice) as customer_count
from walmart_sales;

select
distinct product_line 
from walmart_sales;


select * from walmart_sales

where 

	Branch is null or City is null or Customer_type is null or  Gender	is null or Product_line 
	is null or Unit_price is null or Quantity is null or Tax is null or Total	is null or 
	sale_date is null or sale_day is null or sale_time is null or Payment is null or 
	cogs is null or	gross_margin_percentage is null or gross_income is null or Rating is null;

-- 1. Write a SQL query to retrieve all columns for sales made on '03/03/2019:

select 
* from walmart_sales
where sale_date = '3/3/2019';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Electronic accessories' and the quantity sold is more than 4 in the month of Mar-2019:

select 
product_line,
sale_date,
quantity
from walmart_sales

	where
		product_line = 'Electronic accessories'
		and 
		to_char(sale_date,'yyyy/mm') = '2019/03'
		and
		quantity >= 6
	
group by 1,2,3
order by 3 desc

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

select 
	product_line,
	round(sum(total)) as total_sales,
	count(*) as total_orders
	from walmart_sales
group by 1


-- 4.Write a SQL query to find the top 5 rating branches and cities in Health and beauty category.

select

	distinct branch,
	city,
	Rating
	from walmart_sales
	where product_line = 'Health and beauty'
	order by Rating desc
	

	
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 700 by a member in mode of Cash.:


select 
* from walmart_sales

where 
total >= 700
and payment = 'Cash'
and customer_type = 'Member';


-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:


select

 distinct Gender, Product_line,
 count(Invoice) as total_transactions
 from walmart_sales
 group by 1,2
 order by 3 desc


-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:


select

	year,
	month,
	avg_sales

	from
	(
		select

			extract (year from sale_date) as year,
			extract (month from sale_date) as month,
			avg(total) as avg_sales,
			rank() over(partition by extract (year from sale_date) order by avg(total) desc) as rank
			from walmart_sales
			group by 1,2
	) as t1
	where rank =1

	
-- 8. Write a SQL query to find the top 5 Invoices based on the highest total sales 


 select

	Invoice,
	Branch,
	Sum(total) as total_sales
	from walmart_sales
	group by 1
	order by 3 desc
	limit 5

-- 9. Write a SQL query to find the highest sales amount among the branches 


select

	
	distinct Branch,
	round(Sum(total)) as total_sales
	from walmart_sales
	group by 1
	order by 2 desc

-- 10. Write a SQL query to find the Hioghest number sales among the branches 


select 

	distinct Branch
	Total,
	count(*) as Total_sales
	from walmart_sales
	group by 1
-- 11. Wirte a SQl query to find number of members and non-members (Normal) across the branches

 select 

	 distinct Customer_type,
	 Branch,
	 count (Customer_type) as Number_of_unique_cust
	 from walmart_sales
	 group by 1,2 
	 order by 3 desc

-- 12. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


with hourly_sale
as
(

	select*,
	case
		when extract (hour from sale_time) < 12 then 'MORNING'
		when extract (hour from sale_time) > 12 then 'AFTERNOON'
		else 'EVENING'
		end as shift
		from walmart_sales	

)

select
	shift,
	count(*) as total_orders
	from hourly_sale
	group by shift 


-- 13. write an sql query to find the total sales on 'Thursday'


select 
	distinct Branch,
	sale_day,
	
	round(sum(total)) as total_sales
	
	from walmart_sales
	
	where sale_day = 'Thursday'
	group by 1,2

-- 14. Write a SQL Query to find the total sales on every payment type in all branches


select
      distinct Payment,Branch,
	  round(sum(total)) as total_sales
	  from walmart_sales
	  group by 1,2


-- 15. Write a SQL Query to find the total sales on every payment type in each branch.

select
      distinct Payment,Branch,
	  round(sum(total)) as total_sales
	  from walmart_sales
	  group by 1,2
	  
	  

