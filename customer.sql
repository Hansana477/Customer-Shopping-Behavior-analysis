select *
from customer

--total revenue male vs femalw
select gender, sum(purchase_amount) as revenue
from customer
group by gender

--which cutomer used discount but still spent more than avg
select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' AND purchase_amount >=(select AVG(purchase_amount) from customer)

--top 5 products that have highest avg rating
select item_purchased, Round(AVG(review_rating),2)
from customer
group by item_purchased
order by AVG(review_rating) DESC
offset 0 rows
fetch next 5 rows only

--compare avg purchase amount betwenn express shipping and standart shipping
select Round(AVG(purchase_amount),2), shipping_type
from customer
where shipping_type in ('Standard', 'Express')
group by shipping_type

-- compare avg spend and total revenue between subscribers and non subscribers
select subscription_status, 
COUNT(customer_id),
Avg(purchase_amount) as average,
sum(purchase_amount) as total
from customer
group by subscription_status

--top 5 products that have highest percentage of purchase with discount applied
select item_purchased, round(100*sum(case when discount_applied = 'Yes' Then 1 Else 0 End)/count(*),2) as disc_rate
from customer
group by item_purchased
order by disc_rate desc
offset 0 rows
fetch next 5 rows only

--segment customers into New, Retturning, and loyal based on ther total no of previos purchases and show count of each  segment
 with customer_types as (
 select customer_id, previous_purchases,
 case
	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
 from customer
 )

 select customer_segment, count(*) as "No of customers"
 from customer_types
 group by customer_segment

 --top 3 most purchased in each category
 with item_counts as (
 select category, item_purchased, count(customer_id) as total_orders,
 row_number() over(partition by category order by count (customer_id) desc) as item_rank
 from customer
 group by category, item_purchased
 )

 select item_rank, category, item_purchased, total_orders
 from item_counts
 where item_rank <= 3

 --are customer who are repeat buyers (more than 5 previos purchase) also likely to subscribe
 select subscription_status, count(customer_id) as repeat_buyers
 from customer
 where previous_purchases > 5
 group by subscription_status

 --revenue contribution of each age group
 select age_group, sum(purchase_amount) as total
 from customer
 group by age_group
 order by total desc

