--SQL Retail Sales Analysis 
DROP 	TABLE IF EXISTS retail_sales;
Create table retail_sales (
 	transactions_id int primary key,
	 sale_date DATE,
	 sale_time TIME,
	 customer_id int,
	 gender	VARCHAR(15),
	 age int,
	 category varchar(15),
	 quantity int,
	 price_per_unit	float,
	 cogs float,
	 total_sale float
);
select * from retail_sales;

select count(*) from retail_sales;

select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or customer_id is null
	or gender is null
	or age is null 
	or category is null
	or quantity is null
	or price_per_unit is null
	or cogs is null 
	or total_sale is null;

-- delete the rows which has null values
delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or customer_id is null
	or gender is null
	or age is null 
	or category is null
	or quantity is null
	or price_per_unit is null
	or cogs is null 
	or total_sale is null;

select count(*) from retail_sales;

--Data exploration

--How many sales do we have?
select count(total_sale) from retail_sales;

--How many unique customers do we have?
select count(distinct customer_id) from retail_sales;

-- How many categories do we have?
select distinct category from retail_sales;

--Data analysis and business key problem & answers
--My analysis and findings

--1. retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date='2022-11-05'

--2. Retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022
select * from retail_sales
where 
category ='Clothing' 
and
TO_CHAR(sale_date,'YYYY-MM')='2022-11' 
and 
quantity >=2;

--3. calculate the total sales(total_sale) for each category
select 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by category;

--4. find the average age of customers who purchased items from 'beauty' category
SELECT avg(age) from retail_sales
where category='Beauty'

--5. Find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale>1000;

--6. find the total number of transactions(transaction_id) made by each gender in each category.
select 
	category, 
	gender,
	count(transactions_id) as tota_transactio
from retail_sales
group by category, gender;

--7. calculate the average sale for each month. Find out  best-selling month in each year
select 
	year,
	month,
	avg_sale
from
(
select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale ,
	RANK() over(partition by extract(year from sale_date) order by avg(total_sale) DESC) as rank
from retail_sales
group by 1,2
) as t1
where rank=1;


--8. Find the top 5 customers based on the highest total sales
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order  by 2 desc
limit 5;

--9. Find the number of unique customers who purchased items from each category
select 
	category,
 	count(distinct customer_id)  as unique_customer
from retail_sales
group by category

--10. query to create each shift and number of orders(example morning<=12,afternoon between 12 & 17,Evening>17)
with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		When extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift