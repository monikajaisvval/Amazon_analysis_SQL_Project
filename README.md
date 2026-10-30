# 🛒 Amazon Brazil: SQL Business Analysis

An end-to-end SQL analysis of Amazon Brazil's e-commerce data, answering **14 real-world business questions** on customers, orders, payments, products, and sellers using **MySQL**.

> Completed as part of my Data Analyst internship at **WsCube Tech**.

---

## 📌 Project Overview

Amazon Brazil's data spans the full order lifecycle: who buys, what they buy, how they pay, and how sellers perform. This project uses SQL to turn that raw data into answers a business team could act on.

**Goals**
- Understand customer buying behaviour and payment preferences
- Identify top-performing products, categories, and sellers
- Analyse revenue trends over time
- Practise writing clean, readable, production-style SQL

---

## 🧰 Tools & Concepts

| Category | Details |
|----------|---------|
| Database | MySQL |
| Language | SQL |
| Concepts | Joins, aggregations, `GROUP BY` / `HAVING`, subqueries, CTEs, window functions, `CASE WHEN`, date functions |

---

## 🗂️ Repository Structure

```
amazon-brazil-sql-analysis/
├── amazon_solution.sql      # Solutions to all 14 business questions
├── README.md                # Project documentation
└── (optional) report.pptx   # Presentation of key insights
```

---

## 🗃️ Dataset

The dataset covers Amazon Brazil's e-commerce operations. Typical tables include:

| Table | Description |
|-------|-------------|
| `customers` | Customer details and location |
| `orders` | Order status and timestamps |
| `order_items` | Products, prices, and sellers per order |
| `payments` | Payment type and value |
| `products` | Product category and attributes |
| `sellers` | Seller details and location |

> ⚠️ Update the table names above to match your actual schema.

---

## ❓ Business Questions Answered

1. [Question 1, e.g. Which payment methods are most used, and what share of revenue does each drive?]
2. [Question 2]
3. [Question 3]
4. [Question 4]
5. [Question 5]
6. [Question 6]
7. [Question 7]
8. [Question 8]
9. [Question 9]
10. [Question 10]
11. [Question 11]
12. [Question 12]
13. [Question 13]
14. [Question 14]

> Replace the placeholders with your 14 actual questions. All solutions are in [`amazon_solution.sql`](./amazon_solution.sql).

---

## 💡 Sample Query

**Question:** How do customers pay, and which payment methods drive the most revenue?

```sql
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(SUM(payment_value) * 100.0
          / SUM(SUM(payment_value)) OVER (), 2) AS revenue_share_pct
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;
```

**Result:** [Add a screenshot or a small table of your output here]

---

## 🔍 Key Insights

- [Insight 1, e.g. Credit cards account for X% of total revenue]
- [Insight 2]
- [Insight 3]
- [Insight 4]

---

## ▶️ How to Run

1. Clone this repository
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   ```
2. Create a database in MySQL and import the dataset tables
   ```sql
   CREATE DATABASE amazon_brazil;
   USE amazon_brazil;
   ```
3. Open `amazon_solution.sql` in MySQL Workbench (or any SQL client)
4. Run each query to see the results for the corresponding business question

---

## 📚 What I Learned

- Breaking a business question into clear SQL steps before writing any code
- Using window functions and CTEs to replace nested subqueries
- Writing readable, well-commented queries that others can follow
- Turning query results into insights a business can act on

---

## 🚀 Next Steps

- Build an interactive **Power BI** dashboard from these insights
- Extend the analysis with **Python** (Pandas) for deeper exploration

---

## 👩‍💻 Author

**Monika Jaiswal**
Aspiring Data Analyst | SQL • Excel • Power BI • Python

🔗 [LinkedIn](https://www.linkedin.com/in/moniksjaisvval) · 💻 [GitHub](https://github.com/monikajaisvval)

---

⭐ If you found this project useful, consider giving it a star!
