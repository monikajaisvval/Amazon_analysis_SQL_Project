use amazon;
# Q1. Find the total number of orders fulfilled by each seller state. 

select * from customers;
select s.seller_state, count(distinct oi.order_id) 
from sellers s 
join order_items oi using(seller_id)
join orders o using(order_id)
where o.order_status="delivered"
group by s.seller_state, o.order_status;

#OR

with cte as	
(
	select o.order_id, s.seller_state, row_number() over(partition by s.seller_state, o.order_id order by oi.order_item_id)as rnk
	from order_items oi 
	join orders o using(order_id)
	join sellers s using(seller_id)
    where o.order_status = 'Delivered'
)
select distinct seller_state,
count(case when rnk =1 then 1 END) over(partition by seller_state) as total_order_fulfilled
from cte
order by total_order_fulfilled desc;

#Q2. For each product category, calculate the cumulative revenue generated as orders come in over time.
with cte as
	(	
		select coalesce(pcnt.product_category_name_english, pcnt.product_category_name,'unknown') category, date(o.order_purchase_timestamp) as order_date, sum(odi.price) daily_revenue
        from order_items odi 
        join orders o using(order_id) 
		join products p using(product_id) 
		join product_category_name_translation pcnt using(product_category_name)
        where order_status ='delivered'
		group by category, order_date
	)
select category, order_date, round(daily_revenue, 2) daily_revenue, round(sum(daily_revenue) over(partition by category order by order_date),2) cumulative_sum from cte order by category, order_date;

#Q3. Which payment method do customers use the most, and what is the average order value for each payment type? 

WITH order_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_total
    FROM order_payments
    GROUP BY order_id
),
type_orders AS (
    SELECT DISTINCT
        order_id,
        payment_type
    FROM order_payments
)
SELECT
    t.payment_type,
    COUNT(*)                          AS orders_using_type,
    ROUND(AVG(ot.order_total), 2)     AS avg_order_value,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS popularity_rank
FROM type_orders t
JOIN order_totals ot ON t.order_id = ot.order_id
GROUP BY t.payment_type
ORDER BY orders_using_type DESC;

#Q4. Find the customer who has spent the most money across all their orders.
select customer_unique_id, round(sum(payment_value),2) total_spent from customers c join orders o using(customer_id)
join order_payments op using(order_id) group by customer_unique_id order by total_spent;
#OR
with cte as(select customer_unique_id , sum(payment_value) total_spent from customers c join orders o using(customer_id) join order_payments op using(order_id) 
group by customer_unique_id),
ranked as(
	select customer_unique_id, round(total_spent,2), rank() over(order by total_spent desc) rnk from cte)
select * from ranked where rnk =1;
       
#Q5. Find the average review score for each product category. 
select avg(odr.review_score), p.product_category_name from order_reviews odr left join order_items odi using(order_id) 
left join products p using(product_id) group by p.product_category_name;
#Q6. Find the total number of orders placed by each customer, broken down by the state they live in. 
select c.customer_unique_id, count(o.order_id)total_orders, c.customer_state from orders o left join customers c using(customer_id) 
group by c.customer_unique_id, c.customer_state order by total_orders desc;
#Q7. Identify sellers who registered on the platform but have never fulfilled a single order.
select * from sellers s left join order_items odi using(seller_id) where odi.seller_id is null;
#or
select * from sellers s where not exists(select 1 from order_items odi where s.seller_id = odi.seller_id);
#or
select seller_id from sellers where seller_id not in(select seller_id from order_items);
#Q8. Find the top 5 product categories by total revenue. 
with cte as
	(	
		select sum(odi.price) total_revenue, coalesce(pcnt.product_category_name_english, pcnt.product_category_name,'unknown') category from order_items odi 
		join products p using(product_id) 
		join product_category_name_translation pcnt using(product_category_name)
        join orders o using(order_id)where order_status ='delivered'
		group by category
	),
    ranked as (select category, round(total_revenue,2) as total_revenue, dense_rank() over(order by total_revenue desc) as rnk from cte)
    select category, total_revenue from ranked where rnk <=5 order by rnk;
   
#Q9. Find the median delivery time (in days) between order placement and actual delivery. 
with cte as(
select datediff(order_delivered_customer_date, order_purchase_timestamp) as delivery_days from orders where order_status = 'delivered' and
order_delivered_customer_date is not null and order_purchase_timestamp is not null),
numbered as (select delivery_days, row_number() over(order by delivery_days desc)rn ,count(*) over() as total from cte)
select round(avg(delivery_days),2) as median_delivery_days from numbered where rn in(floor((total+1)/2),ceil((total+1)/2));

#Q10. Find all products that have never been ordered. 
select p.* from products p join order_items odi using(product_id) where odi.order_id is null;
# or
select p.* from products p where not exists(select 1 from order_items odi where p.product_id=odi.product_id);

#Q11. Find sellers who have fulfilled more orders than the average seller on the platform. 
with seller_orders as
	(select seller_id, count(distinct order_id) as total_orders from order_items group by seller_id order by total_orders desc)
select seller_id, total_orders from seller_orders where total_orders > (select avg(total_orders) from seller_orders);

#Q12. Find which Brazilian states have the highest average customer review score for orders delivered there.
with cte as
(select count(*) review_count, avg(odr.review_score) average_review, c.customer_state from order_reviews odr 
left join orders o using(order_id) left join customers c using(customer_id) where o.order_status='delivered'
group by c.customer_state),
ranked as
(select *, rank() over(order by average_review desc) rnk from cte)
select review_count, round(average_review,2)avg_score, customer_state from ranked where rnk=1;

#Q13. Identify customers who have placed orders but never left a review.
select distinct c.customer_unique_id from customers c left join orders o using(customer_id) left join order_reviews odr using(order_id) where o.order_status='delivered' 
group by c.customer_unique_id having count(review_id) =0;

#Q14. Find the month with the highest number of orders placed across the entire platform. 
with cte as(
 select date_format(order_purchase_timestamp,'%y-%m')order_month, count(order_id), rank() over( order by count(order_id) desc) rnk from orders group by order_month)
 select * from cte where rnk =1;
 



