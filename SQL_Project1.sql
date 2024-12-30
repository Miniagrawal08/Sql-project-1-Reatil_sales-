-- create SQL project 1

Create Database SQL_Project1;

drop table retail_sales;

Use SQL_Project1;

-- Create table retail sales:
Create Table retail_sales 
	(
		transactions_id	INT Primary key,
		sale_date Date,
		sale_time Time,
		customer_id	INT,
		gender varchar (6),
		age INT,
		category Varchar(20),	
		quantiy	INT,
		price_per_unit INT,	
		cogs Float,
		total_sale Float
	);


-- Checking data table:
Select * from retail_sales
Limit 2000;

-- checking null values:
select * from retail_sales
where transactions_id is Null
or
sale_time is Null
OR
sale_date is Null
OR
customer_id is Null
OR
gender is Null
OR
age is Null
OR
category is Null
OR
quantiy is Null
OR
price_per_unit is Null
OR
cogs is Null
OR
total_sale is Null;

-- Deleting Null values from the data:
DELETE from retail_sales
where transactions_id is Null
or
sale_time is Null
OR
sale_date is Null
OR
customer_id is Null
OR
gender is Null
OR
age is Null
OR
category is Null
OR
quantiy is Null
OR
price_per_unit is Null
OR
cogs is Null
OR
total_sale is Null;


-- Data Exploration steps:

-- How many Sales we have?
Select Count(transactions_id) from retail_sales;

-- How many customers we have?
Select Count(distinct(customer_id)) from retail_sales;

-- All the category name in the store
Select distinct(category) from retail_sales;



-- Data Analysis and Business key problems and Answers:
-- Q1 write a SQL quesry for retrive the all the columns for sales on '2022-11-05'.

select * from retail_sales
where sale_date = '2022-11-05';

-- Q2 write a sql query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022;

Select 
	*
from retail_sales
where 
category = 'Clothing' 
and 
sale_date LIKE '2022-11%'
and
quantiy >= 4;

-- Q3 write a query to calculate the total sales for each category:
Select category, 
	sum(total_sale) 
from retail_sales
group by category;
 
-- Q4 write a SQL query to find the average age of customer who purchased items from the "Beauty" category:
select avg(age) 
from retail_sales
where category = 'Beauty';

-- Q5 write a sql quaery to find all transections where the total sales is grater than 1000:
select * from retail_sales
where total_sale > 1000;

-- Q6 write a sql query to find the total number of tansactions made by each gender in each category:
select count(transactions_id), 
	gender, 
	category 
from retail_sales
group by category, gender;

-- Q7 write a query to calculate the average sale for each month. Find out best selling month in each year:
select avg(total_sale) as Avg_total_sales,
	date_format(sale_date, '%y') as Sale_year,
	Date_Format(sale_date, '%m') as Sale_month
from retail_sales
group by Sale_year, Sale_month
order by Sale_year, Avg_total_sales desc;

-- Second method for Q7:

WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(sale_date, '%Y') AS sale_year,
        DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
        AVG(total_sale) AS avg_monthly_sale
    FROM 
        retail_sales
    GROUP BY 
        sale_year, sale_month
)
SELECT 
    sale_year, 
    sale_month, 
    avg_monthly_sale
FROM 
    MonthlySales
WHERE 
    avg_monthly_sale = (
        SELECT MAX(avg_monthly_sale)
        FROM MonthlySales AS ms
        WHERE ms.sale_year = MonthlySales.sale_year
    );

-- Q8 write a query to find the top 5 customers based on the highest total sales:
select sum(total_sale) as Total_cust_sale, 
	customer_id 
from retail_sales
group by customer_id
order by Total_cust_sale desc
limit 5;

-- Q9 write a query to find the number of unique customers who purchased items from each category:
select category,
	count(Distinct customer_id) as Unique_customer
from retail_sales
group by category;


-- Q10 write a query to create each shift and number of orders (example Morning<=12, afternoon between 12 and 17 and evening >17)
select count(customer_id) as Num_orders, 
    CASE 
    WHEN Extract(HOUR from sale_time) <='12' THEN 'Morning'
    WHEN Extract(HOUR from sale_time) between '12' and Extract(HOUR from sale_time) <= '17' THEN 'After noon'
    Else 'Evening'
    End as Shift
    from retail_sales
    group by Shift;
