create database sales_project;
use sales_project;

SELECT COUNT(*) AS num_customers_without_dob
FROM customer_sales
WHERE dob IS NULL OR dob = '';

select primary_pincode,gender,count(*) as Num_cust_with_pincode_and_gender
from customer_sales
group by primary_pincode,gender;

select product_name,mrp
from product_sales
where mrp >='50000';

select pincode,count(*) as delivery_person
from deliverypersons_sales
group by pincode;

select delivery_pincode as pincode,count(total_amount_paid)as count_total,sum(total_amount_paid) as sum_total,avg(total_amount_paid) as avg_total,min(total_amount_paid) as min_total
from order_sales
where payment_type='cash' and order_type='buy'
group by delivery_pincode;

select  delivery_person_id,count(*) as count_orders,sum(total_amount_paid) as total_amount
from order_sales
where product_id=12350 or 12348 and tot_units>8 and order_type='buy'
group by delivery_person_id
order by total_amount desc;

select CONCAT(first_name,'  ',last_name) as full_name
from customer_sales
where email LIKE '%@gmail.com';

select delivery_pincode as pincode,avg(total_amount_paid)as avg_amt
from order_sales
where order_type='buy'
group by pincode
having avg(total_amount_paid) >150000;

select  day(str_to_date(order_date,'%d-%m-%y')) as order_day,
date(str_to_date(order_date,'%d-%m-%y')) as order_date,
month(str_to_date(order_date,'%d-%m-%y')) as order_month,
year(str_to_date(order_date,'%d-%m-%y')) as order_year
from order_sales;

select month(str_to_date(order_date,'%d-%m-%y')) as order_month, count(*) as no_orders,
sum(case when order_type='return' then 1 else 0 end ) as returned,
100*(sum(case when order_type='return' then 1 else 0 end))/ count(*) as returned_ratio
from order_sales
group by order_month;

describe order_sales;
alter table product_sales
change column MyUnknownColumn product_id int;

select p.brand,sum(case when o.order_type='buy' then tot_units else 0 end) as tot_unitssold,
sum(case when o.order_type='return' then tot_units else 0 end) as tot_unitsreturn
from product_sales as p
join order_sales as o
on p.product_id=o.product_id
group by p.brand;

select pi.state ,count(distinct c.cust_id) as no_customer,
count(distinct d.delivery_person_id) as no_deliveryperson
from deliverypersons_sales as d
join  customer_sales as c on d.pincode= c.primary_pincode
join pincode_sales as pi on d.pincode = pi.pincode
group by pi.state;

select c.cust_id,sum(o.tot_units) as tot_orders,
sum(case when c.primary_pincode=o.delivery_pincode then o.tot_units else 0 end) as total_orders_withpincode,
sum(case when c.primary_pincode!=o.delivery_pincode then o.tot_units else 0 end) as total_orders_withoutpincode,
(100* sum(case when c.primary_pincode=o.delivery_pincode then o.tot_units else 0 end))/sum(tot_units) as percentage
from customer_sales as c 
join order_sales as o 
on c.primary_pincode=o.delivery_pincode
group by c.cust_id;

select p.product_name,sum(o.tot_units)as total_units,sum(o.total_amount_paid) as total_amt,
sum(o.displayed_selling_price_per_unit*o.tot_units)as total_displayed_sellingprice,
sum(p.mrp*o.tot_units)as total_mrp,
(100.0-100.0*sum(o.total_amount_paid))/sum(o.displayed_selling_price_per_unit*o.tot_units) as net_discount_from_sellingprice,
(100.0-100.0*sum(o.total_amount_paid))/sum(p.mrp*o.tot_units)as net_discount_from_mrp
from product_sales as p
join order_sales as o
on p.product_id=o.product_id
group by p.product_name;

select o.order_id,p.product_name,
(100.0 - 100.0 * sum(o.total_amount_paid)) / sum(abs(o.displayed_selling_price_per_unit * o.tot_units))as discount_selling_price
from product_sales as p
join order_sales as o
on p.product_id=o.product_id
where o.order_type !='return'
group  by o.order_id , p.product_name
having discount_selling_price>10.10
order by discount_selling_price desc;

select p.category ,
sum(o.total_amount_paid)-sum(p.procurement_cost_per_unit*o.tot_units)as absolute_profit,
(100.0-100.0*sum(o.total_amount_paid))/sum(p.procurement_cost_per_unit*o.tot_units) as percentage_profit
from product_sales as p
join order_sales as o on p.product_id=o.product_id
group by p.category
order by absolute_profit desc,percentage_profit desc
limit 1;

SELECT d.name AS delivery_person_name,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 1 THEN 1 ELSE 0 END) AS January,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y')) = 2 THEN 1 ELSE 0 END) AS February,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 3 THEN 1 ELSE 0 END) AS March,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 4 THEN 1 ELSE 0 END) AS April,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 5 THEN 1 ELSE 0 END) AS May,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 6 THEN 1 ELSE 0 END) AS June,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 7 THEN 1 ELSE 0 END) AS July,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 8 THEN 1 ELSE 0 END) AS August,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 9 THEN 1 ELSE 0 END) AS September,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 10 THEN 1 ELSE 0 END) AS October,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 11 THEN 1 ELSE 0 END) AS November,
    SUM(CASE WHEN month(str_to_date(order_date,'%d-%m-%y'))  = 12 THEN 1 ELSE 0 END) AS December
FROM deliverypersons_sales AS d
JOIN order_sales  AS o ON d.delivery_person_id = o.delivery_person_id
WHERE o.order_type != 'return'
GROUP BY d.name;

select c.gender,
sum(o.total_amount_paid)-sum(p.procurement_cost_per_unit*o.tot_units)as absolute_profit,
(100.0-100.0*sum(o.total_amount_paid))/sum(p.procurement_cost_per_unit*o.tot_units) as percentage_profit
from product_sales as p
join order_sales as o on p.product_id=o.product_id
join customer_sales as c on o.delivery_pincode= c.primary_pincode
group by c.gender;

SELECT  o.tot_units,AVG(100.0 - 100.0 * o.total_amount_paid / (o.displayed_selling_price_per_unit * o.tot_units)) AS avg_discount
FROM Order_sales as o
WHERE o.product_id = (SELECT p.product_id FROM Product_sales as p WHERE p.product_name = 'Dell AX420') AND order_type = 'buy'
GROUP BY o.tot_units
ORDER BY o.tot_units;
