CREATE TABLE customer_shopping_data (
    "customer_id" INTEGER PRIMARY KEY,
    "age" INTEGER,
    "gender" VARCHAR(20),
    "item_purchased" VARCHAR(100),
    "category" VARCHAR(50),
    "purchase_amount_(usd)" NUMERIC(10,2),
    "location" VARCHAR(100),
    "size" VARCHAR(10),
    "color" VARCHAR(50),
    "season" VARCHAR(20),
    "review_rating" NUMERIC(3,2),
    "subscription_status" VARCHAR(10),
    "shipping_type" VARCHAR(50),
    "discount_applied" VARCHAR(10),
    "promo_code_used" VARCHAR(10),
    "previous_purchases" INTEGER,
    "payment_method" VARCHAR(50),
    "frequency_of_purchases" VARCHAR(50)
);
#phase 1 basic sql quries

#1 display all records
select*from customer_shopping_data;

#2 display total record
SELECT COUNT(*) AS total_records
FROM customer_shopping_data;

#3 Find unique categories
select distinct "category"
from customer_shopping_data;

#4 Find customers aged above 40
select* from customer_shopping_data
where age > 40;

#5 Find purchases above $80
select* from customer_shopping_data
where "purchase_amount_(usd)" > 80;

#6 Find male customers
select* from customer_shopping_data
where "gender" = 'Male';

#7 Find customers with subscription
select* from customer_shopping_data
where "subscription_status" = 'Yes';

#8 Find customers using PayPal
select* from customer_shopping_data
where "payment_method" = 'PayPal';

#9 Find purchases between $50 and $100
select* from customer_shopping_data
where "purchase_amount_(usd)" between 50 and 100;

#10 Find customers from selected locations
select* from customer_shopping_data
where "location" in ('New York', 'Texas', 'California');

#Phase 2 – Aggregate Function 

#11 Calculate total revenue
select sum("purchase_amount_(usd)") as total_revenue
from  customer_shopping_data;

#12 Calculate average purchase amount

select round(avg("purchase_amount_(usd)"),2) as average_purchase
from  customer_shopping_data;

#13 Find maximum purchase

select max("purchase_amount_(usd)") as maximum_purchase
from  customer_shopping_data;

#14 Find minimum purchase

select min("purchase_amount_(usd)") as minimum_purchase
from  customer_shopping_data;

#15 Count customers by gender

select "gender", count(*) as total_customer
from  customer_shopping_data
group by "gender";

#16 Revenue by category

select "category", sum("purchase_amount_(usd)") as total_revenue
from customer_shopping_data
group by "category"
order by total_revenue desc;

#17 Revenue by season

select "season", sum("purchase_amount_(usd)") as total_revenue
from customer_shopping_data
group by "season"
order by total_revenue desc;

#18 Revenue by location

select "location", sum("purchase_amount_(usd)") as total_revenue
from customer_shopping_data
group by "location"
order by total_revenue desc;

#19 Revenue by payment method

select "payment_method", sum("purchase_amount_(usd)") as total_revenue
from customer_shopping_data
group by "payment_method"
order by total_revenue desc;

#20 Find categories with revenue above $50,000

select "category", sum("purchase_amount_(usd)") as total_revenue
from customer_shopping_data
group by "category"
having sum("purchase_amount_(usd)") > 50000
order by total_revenue desc;

#phase 3 intermediate sql

#21 Find top 5 categories by revenue

select "category", sum("purchase_amount_(usd)")as total_revenue
from customer_shopping_data
group by "category"
order by total_revenue desc
limit 5;

#22 Find top 10 products by purchases

select "item_purchased", count(*) as purchase_count
from customer_shopping_data
group by "item_purchased"
order by purchase_count desc
limit 10;

#23 Find average rating by category

select "category", round(avg("review_rating"),2) as average_rating
from customer_shopping_data
group by "category"
order by average_rating desc;

#24 Compare subscribed vs non-subscribed revenue

SELECT
    CASE
        WHEN "subscription_status" = 'Yes'
            THEN 'Subscribed'
        ELSE 'Not Subscribed'
    END AS subscription_group,
    SUM("purchase_amount_(usd)") AS total_revenue
FROM customer_shopping_data
GROUP BY subscription_group
ORDER BY total_revenue DESC;

#25 Calculate discount usage percentage

select
      round(100.0*sum(
           case
		       when "discount_applied" = 'Yes'
			       then 1
			   else 0
		  end )/ count(*),
		  2
	) as discount_usage_percentage
from customer_shopping_data;

#26 Create age groups

select
      case
	      when "age" between 18 and 25 then '18-25'
		  when "age" between 26 and 35 then '26-35'
		  when "age" between 36 and 45 then '36-45'
		  when "age" between 46 and 55 then '46-55'
		  else '56+'
	  end as "age_group"
from customer_shopping_data;

#27 Calculate revenue by age group

select
      case
	      when "age" between 18 and 25 then '18-25'
		  when "age" between 26 and 35 then '26-35'
		  when "age" between 36 and 45 then '36-45'
		  when "age" between 46 and 55 then '46-55'
		  else '56+'
	  end as "age_group", sum("purchase_amount_(usd)") as total_revenue
from customer_shopping_data
group  by "age_group"
order by total_revenue desc;

#28 Find most popular payment method

select "payment_method", count(*) as total_purchase
from customer_shopping_data
group by "payment_method"
order by total_purchase desc;

#29 Find average previous purchases by category

select "category", round(avg("previous_purchases"),3) as avg_previous_purchase
from customer_shopping_data
group by "category"
order by avg_previous_purchase desc;

#30 Compare spending by frequency

select "frequency_of_purchases",count(*) as total_records,
round(avg("purchase_amount_(usd)"), 2) as avg_spending
from customer_shopping_data
group by frequency_of_purchases
order by avg_spending desc;

#phase 4 Advanced SQL 

#31 Find second-highest purchase amount

select max("purchase_amount_(usd)") as second_highest_purchase
from customer_shopping_data
where "purchase_amount_(usd)" < (
       select max("purchase_amount_(usd)")
	   from customer_shopping_data
);

#32 Find products whose revenue is above average product revenue

select "item_purchased", sum("purchase_amount_(usd)")as product_revenue
from customer_shopping_data
group by "item_purchased"
having sum("purchase_amount_(usd)") > (
       select avg(product_revenue)
   from(
        select sum("purchase_amount_(usd)")as product_reveneu
	 from customer_shopping_data
	 group by "item_purchased"
) as product_summry
)
order by product_revenue desc;

#33 Rank categories by revenue

select "category", sum("purchase_amount_(usd)") as total_revenue,
rank() over( order by sum("purchase_amount_(usd)")desc) as category_rank
from customer_shopping_data
group by "category"
order by "category_rank";

#34 Find top 3 products in each category

with product_revenue as (
  	 	select
		   "category",
		   "item_purchased",
		   sum("purchase_amount_(usd)")as total_revenue
		from customer_shopping_data
		group by "category", "item_purchased"
),
ranks_products as (
      select
	       "category",
		   "item_purchased",
		   total_revenue,
		   dense_rank() over(partition by "category" order by total_revenue desc)as product_rank
		   from product_revenue
)
select
      "category",
	  "item_purchased",
	  total_revenue,
	  product_rank
from ranks_products
where product_rank <= 3
order by "category" , product_rank;
	  	  
#35 Calculate percentage contribution of each category

with category_revenue as (
     select
	       "category",
		   sum("purchase_amount_(usd)")as total_revenue
		   from customer_shopping_data
		   group by "category"
)
select
      "category",
	  total_revenue,
	  round(
	        100.0 * total_revenue
			/ sum(total_revenue) over(),
			2
		)as revenue_percentage
from category_revenue
order by revenue_percentage desc;

#36 Calculate running revenue across ranked products

with product_revenue as(
          select
		        "item_purchased",
				sum("purchase_amount_(usd)")as total_revenue
				from customer_shopping_data
				group by "item_purchased"
),
ranked_products as(
          select
		       "item_purchased",
			    total_revenue,
				row_number() over(order by total_revenue desc) as product_rank
				from product_revenue
)
select
     "item_purchased",
	 total_revenue,
	 product_rank,
	 sum(total_revenue)over(order by product_rank rows between unbounded preceding and current row)as running_revenue
from ranked_products
order by product_rank;

#37 Compare each category  revenue with overall revenue

with category_revenue as(
            select
			    "category",
				sum("purchase_amount_(usd)")as total_revenue
				from customer_shopping_data
				group by "category"
				
),
overall_revenue as (
         select
		      sum("purchase_amount_(usd)")as grand_total
			  from customer_shopping_data
)
select
    c."category",
    c.total_revenue,
    o.grand_total,
    ROUND(
        100.0 * c.total_revenue / o.grand_total,
        2
    ) as revenue_percentage
from category_revenue c
cross join overall_revenue o
order by c.total_revenue desc;

#38 Find customers with previous purchases above average

select "customer_id", "age", "previous_purchases"
from customer_shopping_data
where "previous_purchases" > (
        select avg("previous_purchases")
		from customer_shopping_data
)
order by "previous_purchases" desc;

#39 Find highest revenue location in each season

with location_revenue as(
      select
	  "season",
	  "location",
	  sum("purchase_amount_(usd)")as total_revenue
	  from customer_shopping_data
	  group by "season", "location"
	  
),
ranked_location as(
        select
		"season",
		"location",
		total_revenue,
		rank() over(partition by "season" order by total_revenue desc) as location_rank
		from location_revenue
)
select
      "season",
	  "location",
	  total_revenue
from ranked_location
where location_rank = 1
order by "season";

#40 Create customer spending segments
#Low: purchase amount below $50
#Medium: $50–$80
#High: above $80

with customer_spending as (
    select
        "customer_id",
        "purchase_amount_(usd)" as spending
    from customer_shopping_data
),
spending_segments as(
          select
		       "customer_id",
			   spending,
			   case
			       when spending < 50 then 'low'
				   when spending <= 80 then 'medium'
					else 'high'
				end as spending_segment
			from customer_spending
)
select
     spending_segment,
	 count(*) as total_record,
	 round(avg(spending),2)as avg_spending,
	 sum(spending)as total_revenue
from spending_segments
group by spending_segment
order by
       case spending_segment
	    when 'low' then 1
        when 'medium' then 2
        when 'high' then 3
    end;