--SELECT * FROM pizza_sales
USE pizaaDB

/* 1. Total revenue: the sum of the total price of all pizza orders.*/

SELECT SUM(total_price) AS TotalRevenue
FROM pizza_sales

/*2. Average Order Value:- the average amount spent per order,i.e dividing the
total revenue by the total no. of orders*/

SELECT (SUM(total_price)/COUNT(DISTINCT order_id)) AS AvgOrdersValue
FROM pizza_sales

/*3. Total pizaa sold*/

SELECT SUM(quantity) AS TotalPizzaSold 
FROM pizza_sales

--4.Total orders

SELECT COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales

--5.Average Pizzas per Order: total pizza sold divided by total order

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2))/
CAST(COUNT(DISTINCT order_id)AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS AvgPizzaPerOrder
FROM pizza_sales
--Daily Trend for Total Orders
--it displays the daily trend of total orders over a specific time period
--No. of orders on each day
SELECT DATENAME(WEEKDAY,order_date) as order_day,
COUNT(DISTINCT order_id) AS TotalOrder
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY,order_date)

--Hourly trend: determine the peak hour
SELECT DATEPART(HOUR,order_time) AS OrderHour,
COUNT(DISTINCT order_id) AS NumOfOrder
FROM pizza_sales
GROUP BY DATEPART(HOUR,order_time)
ORDER BY DATEPART(HOUR,order_time)

--peak hour
SELECT TOP 1 DATEPART(HOUR, order_time) AS PeakHour,
       COUNT(DISTINCT order_id) AS NumOfOrder
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY NumOfOrder DESC;

--Percentage of Sales by pizza category

SELECT 
    pizza_category,
    SUM(total_price) AS Category_Sales,
    ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date)=1), 2) AS Sales_Percentage
FROM pizza_sales
WHERE MONTH(order_date)=1 --this indicate the data for january
--to find for the quarter DATEPART(QUARTER,order_date)
GROUP BY pizza_category
ORDER BY Sales_Percentage DESC;

--------------------
--this indicate the data for a year
SELECT 
    pizza_category,
    SUM(total_price) AS Category_Sales,
    ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales ), 2) AS Sales_Percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Sales_Percentage DESC;

--Sales percentage according to size
SELECT pizza_size,CAST(SUM(total_price) AS DECIMAL(10,2)) AS TotalSales,
CAST(SUM(total_price)*100/
(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER,order_date)=1)AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
WHERE DATEPART(QUARTER,order_date)=1
GROUP BY pizza_size
ORDER BY PCT DESC;

--TOTAL pizza sold by pizza category--
SELECT * FROM pizza_sales
---
SELECT pizza_category,SUM(quantity) AS pizza_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pizza_sold DESC

--TOP 5 BEST SELLERS by PIZZAS SOLD:---

SELECT  TOP 5 pizza_name,SUM(quantity) AS pizza_sold
FROM pizza_sales
GROUP By pizza_name
ORDER BY pizza_sold DESC

--BOTTOM 5 WORST SELLER by total pizza---
SELECT  TOP 5 pizza_name,SUM(quantity) AS pizza_sold
FROM pizza_sales
--WHERE MONTH(order_date)=1  --to get for only first month
GROUP By pizza_name
ORDER BY pizza_sold
