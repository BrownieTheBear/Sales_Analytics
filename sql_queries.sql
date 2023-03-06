
/* What is the maximum volume sold per productline?
*/
SELECT max(QUANTITYORDERED) as max_quant_ordered, PRODUCTLINE
fROM `customeranalytics-379113.999.sales`
group by PRODUCTLINE LIMIT 1000;


/* Which country sold the most product?
*/
select (sum(c.sales)) as total_product_sales, c.country
from `customeranalytics-379113.999.sales` as c
group by COUNTRY
order by (sum(c.SALES)) desc
limit 1;


/* Who is the best customer? Over all years
*/
      select sum(sales) as total_sales, c.CUSTOMERNAME as customer
      from `customeranalytics-379113.999.sales` as c
      group by c.CUSTOMERNAME
      order by sum(sales) desc
      limit 1;

/*RFM (Recency, Frequency, Monetary) Marketing Analysis
*/
select CUSTOMERNAME as customer,
       max(ORDERDATE) as most_recent_order,
       count(*) as purchase_frequency_max_revenue_year,
       sum(sales) as total_sales_revenue
from `customeranalytics-379113.999.sales` as c
where c.YEAR_ID = 2005
        and c.STATUS not like '%C%'
        and c.status not like '%O%'
        and c.status not like '%D%'
group by CUSTOMERNAME
order by sum(sales) desc;


/* What was the best year for sales?
*/
select sum(sales) as total_sales, YEAR_ID as year
from `customeranalytics-379113.999.sales`
group by YEAR_ID
order by total_sales desc
limit 1;

/*  calculate avg revenue per deal size and the count of the number of X sized deals within (where year = n) year y
*/
select DISTINCT(DEALSIZE) as dealsize,
avg(sales) as avg_revenue_per_deal,
YEAR_ID FROM `customeranalytics-379113.999.sales`
group by DEALSIZE, YEAR_ID
ORDER BY YEAR_ID;

/* Here we observe that in 2005 the business was only operational across 5 months */

select sum(sales), MONTH_ID from
`customeranalytics-379113.999.sales`
where YEAR_ID = 2005
group by MONTH_ID
order by MONTH_ID
limit 1000;

/* Now we can check other years for >5 month business operations over 12 months to validate the reason behind low profit for 2005 - let's check 2004 */

select sum(sales) as total_sales, MONTH_ID
from `customeranalytics-379113.999.sales`
where YEAR_ID = 2004
group by MONTH_ID
order by MONTH_ID;

/* Now we can check other years for >5 month business operations over 12 months to validate the reason behind low profit for 2004 - let's check 2003 */

select sum(sales) as total_sales, MONTH_ID
from `customeranalytics-379113.999.sales`
where YEAR_ID = 2003
group by MONTH_ID
order by MONTH_ID;


select sum(SALES) as total_sales, TERRITORY
from `customeranalytics-379113.999.sales`
group by TERRITORY
order by sum(sales) desc;

/* What was the best month for sales in 2003?
*/

select sum(SALES) as total_monthly_sales, MONTH_ID
from `customeranalytics-379113.999.sales`
where YEAR_ID= 2003
group by MONTH_ID
order by sum(SALES) desc;

/* Calculate monthly rolling averages for 2003
*/
select YEAR_ID,
MONTH_ID,SALES,
  avg(SALES) OVER
  (PARTITION BY YEAR_ID, MONTH_ID
  ORDER BY ORDERDATE
     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW )
     as moving_average
from `customeranalytics-379113.999.sales`
where YEAR_ID = 2003
ORDER BY MONTH_ID
