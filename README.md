# Pizza-Sales-Analysis
SQL project analyzing pizza sales data using joins, aggregation, and window functions.
# 🍕 Pizza Sales Analysis (SQL Project)

A beginner-friendly SQL project to analyze pizza sales using real-world business questions.

## 📌 Topics Covered:
- Total revenue and quantity sold
- Most ordered pizza types and categories
- Revenue trends over time (daily, monthly)
- Cumulative revenue using window functions
- Ranking top 3 pizza types in each category

## 🛠 Tools Used:
- SQL (MySQL)
- DB Browser / MySQL Workbench

## 🔍 Sample Query:
```sql
SELECT t.category, SUM(o.quantity) AS total_quantity
FROM pizza_types t
JOIN pizzas p ON t.pizza_type_id = p.pizza_type_id
JOIN order_details o ON o.pizza_id = p.pizza_id
GROUP BY t.category
ORDER BY total_quantity DESC;
