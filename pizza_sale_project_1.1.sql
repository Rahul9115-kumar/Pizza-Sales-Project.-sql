-- Basic:

1.-- Retrieve the total number of orders placed.

select count(order_id)as total_orders from orders

2.-- Calculate the total revenue generated from pizza sales.

Select 
ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM 
    order_details 
JOIN 
    pizzas 
ON 
    pizzas.pizza_id = order_details.pizza_id;
    
3.-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size, 
    COUNT(order_details.order_details_id) AS order_count
FROM 
    pizzas 
JOIN 
    order_details 
ON 
    pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizzas.size 
ORDER BY 
    order_count DESC;    
    
4.-- Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

5.-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

Intermediate:

1.-- Join the necessary tables to find the total quantity of each pizza category ordered

SELECT 
    pizza_types.category, 
    SUM(order_details.quantity) AS quantity
FROM 
    pizza_types 
JOIN 
    pizzas 
ON 
    pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details 
ON 
    order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category 
ORDER BY 
    quantity DESC;
    
2.-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);    

3.-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category

4.-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) as avg_pizza_order_perday
FROM 
    ( SELECT 
            orders.order_date, 
            SUM(order_details.quantity) AS quantity
        FROM 
            orders 
        JOIN 
            order_details 
        ON 
            orders.order_id = order_details.order_id
        GROUP BY 
            orders.order_date
    ) AS subquery;
    
5.-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name, 
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM 
    pizza_types 
JOIN 
    pizzas 
ON 
    pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN 
    order_details 
ON 
    order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.name 
ORDER BY 
    revenue DESC 
LIMIT 3;

Advanced:

1.-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types. category,
round(sum(order_details.quantity*pizzas.price) / (select 
round(sum(order_details.quantity * pizzas. price),
      2) as total_sales
from 
order_details
   join 
   pizzas on pizzas.pizza_id = order_details. pizza_id)*100,2) as revenue
 from pizza_types join pizzas 
 on pizza_types.pizza_type_id = pizzas. pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;

2.-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT 
    name, 
    revenue 
FROM 
    (
        SELECT 
            category, 
            name, 
            revenue, 
            RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
        FROM 
            (
                SELECT 
                    pizza_types.category, 
                    pizza_types.name, 
                    SUM(order_details.quantity * pizzas.price) AS revenue
                FROM 
                    pizza_types 
                JOIN 
                    pizzas 
                ON 
                    pizza_types.pizza_type_id = pizzas.pizza_type_id
                JOIN 
                    order_details 
                ON 
                    order_details.pizza_id = pizzas.pizza_id
                GROUP BY 
                    pizza_types.category, 
                    pizza_types.name
            ) AS subquery_a
    ) AS subquery_b
WHERE 
    rn <= 3;
    
3.-- Analyze the cumulative revenue generated over time.

SELECT 
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM 
    (
        SELECT 
            orders.order_date,
            SUM(order_details.quantity * pizzas.price) AS revenue
        FROM 
            orders
        JOIN 
            order_details 
        ON 
            orders.order_id = order_details.order_id
        JOIN 
            pizzas 
        ON 
            order_details.pizza_id = pizzas.pizza_id
        GROUP BY 
            orders.order_date
    ) AS sales;
    


    
    

    
