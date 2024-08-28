# Walmart Sales Analysis 2019 SQL Project

## Project Overview

**Project Title**: Walmart sales Analysis 2019
**Level**: Beginner  
**Database**: `project_p1_walmart_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up Walmart sales database from 2019, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project reflects a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a 2019 Walmart sales database with the already available sales data.
2. **Data Cleaning**: Identifying and removing any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Performing basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Using SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Project_p1_walmart_db`.
- **Table Creation**: A table named `walmart_sales` is created to store the sales data. The table structure includes columns for Invoice, 
Branch, City, Customer_type, Gender, Product_line, Unit_price, Quantity, Tax, Total, sale_date, sale_day, sale_time, Payment, cogs, gross_margin_percentage, gross_income, Rating.

```sql
CREATE DATABASE Project_P1_walmart_db;

CREATE TABLE walmart_sales
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
	Rating float
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determining the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

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

delete from walmart_sales

where

	Branch is null or City is null or Customer_type is null or  Gender	is null or Product_line 
	is null or Unit_price is null or Quantity is null or Tax is null or Total	is null or 
	sale_date is null or sale_day is null or sale_time is null or Payment is null or 
	cogs is null or	gross_margin_percentage is null or gross_income is null or Rating is null;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '3/3/2019**:
```sql
select 
* from walmart_sales
where sale_date = '3/3/2019';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Electronic accessories' and the quantity sold is more than 4 in the month of Mar-2019**:
```sql
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
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select 
	product_line,
	round(sum(total)) as total_sales,
	count(*) as total_orders
	from walmart_sales
group by 1
```

4. **Write a SQL query to find the top 5 rating branches and cities in Health and beauty category**:
```sql
select

	distinct branch,
	city,
	Rating
	from walmart_sales
	where product_line = 'Health and beauty'
	order by Rating desc
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 700 by a member in mode of Cash.**:
```sql
select 
* from walmart_sales

where 
total >= 700
and payment = 'Cash'
and customer_type = 'Member';
```

6. **Write a SQL query to find the total number of transactions (Invoice) made by each gender in each category.**:
```sql
select

 distinct Gender, Product_line,
 count(Invoice) as total_transactions
 from walmart_sales
 group by 1,2
 order by 3 desc
```

7. **7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **8. Write a SQL query to find the top 5 Invoices based on the highest total sales  **:
```sql
select

	Invoice,
	Branch,
	Sum(total) as total_sales
	from walmart_sales
	group by 1
	order by 3 desc
	limit 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select

	
	distinct Branch,
	round(Sum(total)) as total_sales
	from walmart_sales
	group by 1
	order by 2 desc
```

10. **Write a SQL query to find the Hioghest number sales among the branches. **:
```sql
select 

	distinct Branch
	Total,
	count(*) as Total_sales
	from walmart_sales
	group by 1
```

11. **Wirte a SQl query to find number of members and non-members (Normal) across the branches. **:
```sql
select 

	 distinct Customer_type,
	 Branch,
	 count (Customer_type) as Number_of_unique_cust
	 from walmart_sales
	 group by 1,2 
	 order by 3 desc
```


12. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) **:
```sql
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

```


13. **write an sql query to find the total sales on 'Thursday'**:
```sql
select 
	distinct Branch,
	sale_day,
	
	round(sum(total)) as total_sales
	
	from walmart_sales
	
	where sale_day = 'Thursday'
	group by 1,2
```

14. **Write a SQL Query to find the total sales on every payment type in all branches.**:
```sql
select
      distinct Payment,
	  round(sum(total)) as total_sales
	  from walmart_sales
	  group by 1
```
15. **Write a SQL Query to find the total sales on every payment type in each branch.**
```sql
select
      distinct Payment,Branch,
	  round(sum(total)) as total_sales
	  from walmart_sales
	  group by 1,2
```



## Findings

- **Customer Demographics**: The dataset includes customers using different payment methods, with sales distributed across different categories such as Electronic accessories and Health and beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 700, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons and also sales happening within a month.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or any suggestions, please feel free to get in touch!


