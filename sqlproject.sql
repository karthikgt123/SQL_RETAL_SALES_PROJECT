use sqlproject

create table project_analysis (
transactions_id	int primary key,
sale_date date,
sale_time	time,
customer_id	int,
gender varchar(15),
age int,
category varchar(50),
quantiy int,
price_per_unit	float,
cogs float,
total_sale float
)

--data cleaning
select * from dbo.retail_anaylsis
where transactions_id is null 
or
sale_date is null
or
customer_id is null
or 
sale_time is null 
or 
gender is null
or
age is null 
or 
category is null
or 
quantiy is null
or 
price_per_unit is null 
or 
cogs is null 
or 
total_sale is null 


delete from dbo.retail_anaylsis
where transactions_id is null 
or
sale_date is null
or
customer_id is null
or 
sale_time is null 
or 
gender is null
or
age is null 
or 
category is null
or 
quantiy is null
or 
price_per_unit is null 
or 
cogs is null 
or 
total_sale is null 

select count(*) from dbo.retail_anaylsis

----data exploration 
how many unique customer are there 

select count(distinct customer_id)from dbo.retail_anaylsis

--what are unique category?

select distinct category from dbo.retail_anaylsis


--data analysis and bussines key problems 

--1) write a query to have all records on the date '2023-11 and category is clothing and quantity is <=4


SELECT * 
FROM dbo.retail_anaylsis
WHERE category = 'clothing'
AND FORMAT(sale_date, 'yyyy-MM') = '2023-11'
AND quantiy <= 4;

--Q3)write sql query to find the total sales for each category 
 select category ,sum(total_sale) as net_sales ,count(category) as category_count from dbo.retail_anaylsis
 group by category

 --Q4)-write a query to find the average age of the customer who purchased items from thr beauty category 

 select 
 avg(age) as average_age  from retail_project
 where category = 'beauty'
 --Q-5)-write a query to find the transcations where the total sales is greater then 1000

 select transactions_id from retail_project
 where total_sale > 1000

 --Q-6) write a query to find the total transaction made by each gender in each category 

select gender, category,count(*) as cnt_transaction
from retail_project 
group by gender, category 
order by category,gender

--Q-7)write a sql to find the average sale of each month , find out the best selling month in each year
select * from retail_project

select years , months,avg_sales from 
(select year(sale_date) as years,month(sale_date) as months ,
avg(total_sale) as avg_sales,
rank() over(partition by year(sale_date) order by avg(total_sale) desc ) rnk
from retail_project
group by year(sale_date), month(sale_date))as t1
where rnk =1

--Q-8)-write sql query to find to 5 customers based on the total sales ?
select top 5 customer_id,total_sales from
(select customer_id , sum(total_sale) as total_sales,
rank() over (partition by customer_id order by sum(total_sale) desc) rnk
from retail_project
group by customer_id )as t1
where rnk=1


select top 5 customer_id , sum(total_sale) as total_sales from retail_project
group by customer_id
order by total_sales desc

-Q-9)-write a sql query to find unique customer who purchased items from each category

select category,count(distinct customer_id) as unique_customer
from retail_project
group by category

--Q-10)-write a sql query to create each shift and number of orders (example morning <=12, afternoon between 12 and 17 and >17)


WITH hourly_order AS (
    SELECT *,
        CASE 
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
            ELSE 'evening'
        END AS shifts
    FROM retail_project
)
SELECT 
   shifts,count(*)
FROM hourly_order
GROUP BY shifts;
