"Best toy product sales and quantity"

select
	pd."Product_Name",
	sum(sl."Units") as Qty,
	round(sum(pd."Product_Price"*sl."Units"), 0) as total_sales
from products pd
join sales sl on (pd."Product_ID"=sl."Product_ID")
group by pd."Product_Name"
order by total_sales desc
limit 10;


"Best toy product category sales"

select
	pd."Product_Category",
	round(sum(pd."Product_Price"*sl."Units"), 0) as total_sales
from products pd
join sales sl on (pd."Product_ID"=sl."Product_ID")
group by pd."Product_Category"
order by total_sales desc;

"Best sales location"

select
	st."Store_Location",
	round(sum(pd."Product_Price"*sl."Units"), 0) as total_sales 
from stores st
join sales sl on (st."Store_ID"=sl."Store_ID")
join products pd on (sl."Product_ID"=pd."Product_ID")
group by st."Store_Location"
order by total_sales desc;

"Sales by quarter "

with cte_date as (
	select 
		date_part('year', sl."Date") as year,
		date_part('quarter', sl."Date") as quarter,
		'Q' || date_part('quarter', sl."Date") || ' ' || date_part('year', sl."Date") as date_sales,
		round(sum(pd."Product_Price" *sl."Units"), 0)  as total_sales
	from sales sl
	join products pd on (sl."Product_ID"=pd."Product_ID")
	group by
		date_part('quarter', sl."Date"),
		date_part('year', sl."Date")
)
select
	cte.date_sales,
	cte.total_sales
from cte_date cte
order by cte.year, cte.quarter;

"Toy sales by toy store and city"

select
	st."Store_Name",
	st."Store_City",
	count(sl."Sale_ID") as Total_customers,
	sum(pd."Product_Price"*sl."Units") as total_sales
from stores st
join sales sl on (st."Store_ID"=sl."Store_ID")
join products pd on (sl."Product_ID"=pd."Product_ID")
group by st."Store_Name", st."Store_City" 
order by total_sales desc
limit 5;




