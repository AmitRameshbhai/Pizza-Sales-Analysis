-- 🍕 Pizza Sales Analysis
-- 🔧 SQL Project by Amit Rameshbhai
-- 📅 Date: April 2025
-- 💡 Contains 12+ SQL queries analyzing sales, revenue, and trends

create database pizzahut;
use pizzahut;
SELECT 
    *
FROM
    pizzas;
SELECT 
    *
FROM
    pizza_types;

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

SELECT 
    *
FROM
    orders;

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- now Question And Answer

-- Basic:
-- 1.Retrieve the total number of orders placed.orders

SELECT 
    COUNT(order_id)
FROM
    orders AS total_orders;
    
-- 2.Calculate the total revenue generated from pizza sales

SELECT 
    ROUND(SUM(p.price * o.quantity), 2) AS total_sales
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id;
    
-- 3.Identify the highest-priced pizza.
 
SELECT 
    t.name, p.price
FROM
    pizza_types t
        JOIN
    pizzas p ON t.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- 4.Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(o.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;

-- 5.List the top 5 most ordered pizza types along with their quantities.

SELECT 
    t.name, SUM(o.quantity) AS Total_Quentity
FROM
    pizza_types t
        JOIN
    pizzas p ON t.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY t.name
ORDER BY Total_Quentity DESC
LIMIT 5;

-- 6.Join the necessary tables to find the total quantity of each pizza category ordered. 

SELECT 
    t.category, SUM(o.quantity) AS Total_Quentity
FROM
    pizza_types t
        JOIN
    pizzas p ON t.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY t.category
ORDER BY Total_Quentity DESC;

-- 7. Determine the distribution of orders by hour of the day

select hour(order_time) as hours, count(order_id) as order_count from orders
group by hours order by order_count desc;

-- 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    pt.category, 
    SUM(od.quantity) AS total_orders
FROM 
    pizzahut.order_details od
JOIN 
    pizzahut.pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizzahut.pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY 
    total_orders DESC;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    round(avg(total_quantity),0)
FROM
    (SELECT 
        o.order_date, SUM(d.quantity) AS total_quantity
    FROM
        orders o
    JOIN order_details d ON o.order_id = d.order_id
    GROUP BY o.order_date) AS order_quantity;
    
-- 10. Determine the top 3 most ordered pizza types based on revenue.

select t.name,
sum(d.quantity * p.price) as ravenue
from pizza_types t
join  pizzas p
on t.pizza_type_id = p.pizza_type_id
join order_details d 
on d.pizza_id = p.pizza_id 
group by t.name order by ravenue desc limit 3;

-- 10. Calculate the percentage contribution of each pizza type to total revenue

SELECT 
    t.name AS pizza_type,
    ROUND(SUM(d.quantity * p.price) * 100 / (SELECT 
                    SUM(o.quantity * p2.price)
                FROM
                    order_details o
                        JOIN
                    pizzas p2 ON o.pizza_id = p2.pizza_id),
            2) AS revenue_percentage
FROM
    pizza_types t
        JOIN
    pizzas p ON t.pizza_type_id = p.pizza_type_id
        JOIN
    order_details d ON d.pizza_id = p.pizza_id
GROUP BY t.name
ORDER BY revenue_percentage DESC;


-- 12. Analyze the cumulative revenue generated over time.

select order_date,
sum(ravenue) over (order by order_date) 
from
(select o.order_date,
sum(d.quantity*p.price)  as ravenue
from order_details d 
join pizzas p 
on d.pizza_id = p.pizza_id
join orders o
on o.order_id = d.order_id
group by o.order_date) as sales;

-- 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, ravenue,
rank() over(partition by category order by ravenue desc) as rn
from
(select t.category,t.name,
sum(d.quantity*p.price) as ravenue
from pizza_types t
join pizzas p 
on t.pizza_type_id = p.pizza_type_id
join order_details d
on d.pizza_id = p.pizza_id
group by t.category,t.name) as a;




    



