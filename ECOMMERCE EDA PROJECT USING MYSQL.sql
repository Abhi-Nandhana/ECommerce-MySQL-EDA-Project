-- DATA CLEANING--

select* from ecommerce;

-- creating a alternative table instead of working with raw data--

create table ecommerce2 like ecommerce;
select* from ecommerce2;
insert ecommerce2 select* from ecommerce;
select* from ecommerce2;
select*,
row_number() over( partition by ProductID, ProductName, Category, Price, Rating, NumReviews, StockQuantity, Discount, Sales, DateAdded) as row_num from ecommerce2;

-- IDENTIFY ANY DUPLICATES--


with dupli as (
select*,
row_number() over( partition by ProductID, ProductName, Category, Price, Rating, NumReviews, StockQuantity, Discount, Sales, DateAdded) as row_num from ecommerce2
)
select * from dupli where row_num>1;

select* from ecommerce2;

-- CHANGING  DATEADDED FROM TEXT TO DATE--
select  DateAdded, str_to_date( DateAdded, '%Y-%m-%d')  from ecommerce2;


-- UPDATING IT TO TABLE--
update ecommerce2 set DateAdded = str_to_date( DateAdded, '%Y-%m-%d') ;


-- CHANGING DATATYPE--

alter table ecommerce2 modify column DateAdded date;
alter table ecommerce2 modify price decimal(10,2), modify Rating decimal(4,2), modify discount decimal(10,2);


-- 1. WHAT IS THE MAX NUMBER OF DISCOUNT GIVEN--

select max(Discount) from ecommerce2;


-- 2. WHAT IS THE MAX SOLD PRODUCT--

select ProductName,max(sales) from ecommerce2 group by ProductName order by max(sales) desc;


-- 3. WHAT IS THE MIN SOLD PRODUCT--

select ProductName,min(sales) from ecommerce2 group by ProductName order by min(sales) desc;

-- 4. WHAT IS THE MAX PRICE OF THE PRODUCT--

select max(price) from ecommerce2;

-- 5. WHAT PRODUCTS ARE SOLD AT THE HIGHEST PRICE--

select ProductName, max(price) from ecommerce2 group by ProductName order by max(price) desc ;

-- 6. WHAT IS THE HIGHEST RATING --
select max(rating) from ecommerce2;

-- 7. WHICH CATEGORY PRODUCTS HAVE THE HIGHEST SALES--
 select Category, max(sales) from ecommerce2 group by Category order by max(sales) desc ;
 
 -- 8. WHICH CATEGORY PRODUCTS HAVE THE LOWEST SALES--
 select Category, min(sales) from ecommerce2 group by Category order by min(sales) desc ;

-- 9. HOW MANY SLAES IS TAKEN PLACE--

select count(sales) from ecommerce2;

-- 10. WHAT IS THE TOTAL NUMBEER OF SALES--

select sum(sales) from ecommerce2;

-- 11. WHAT IS THE TOTAL PRICE SPENT ON  each PRODUCT--

select productname ,sum(price) from ecommerce2 group by ProductName order by sum(price) desc ;

-- 12. WHAT IS THE COUNT OF EACH PRODUCT--

select productname,count(productname) from ecommerce2 group by ProductName order by count(productname) desc;

-- 13. HOW MANY STOCKS ARE LEFT ON EACH PRODUCT--

select productname, StockQuantity from ecommerce2 group by productname, StockQuantity order by StockQuantity desc;

-- 14. HOW MANY PRODUCTS ADDED AND SOLD IN 2024--

select sum(Sales) as ProdSoldIn2024 from ecommerce2 where year(DateAdded) = 2024;


-- 15. HOW MANY PRODUCTS PER CATEGOGORY--

select Category, COUNT(ProductName) as ProductCount from ecommerce2 group by Category order by ProductCount desc;

-- 16. WHAT IS AVERAGE DISCOUNT PER CATEGORY--
select category, avg(discount) from ecommerce2 group by Category;

-- 17. TOP 10 BEST SELLING PRODUCTS--
select ProductName, Sales from ecommerce2 order by Sales desc limit 10;

-- 18. PRODUCT WITH HIGH RATING BUT LOW SALES--
select ProductName, Rating, Sales from ecommerce2 where Rating >= 4.5 and Sales < 50 order by Rating desc;

-- 19. PRODUCT WITH MORE REVIEWS BUT POOR RATING--

select ProductName, Rating, NumReviews from ecommerce2 where Rating < 3 and NumReviews > 100 order by NumReviews desc;

-- 20. HOW MANY PRODUCTS ARE ADDED EACH YEAR--

select year(DateAdded) as yearadd, count(ProductName) as ProductsAdded from ecommerce2 group by year(DateAdded) order by yearadd;

-- 21. AVERAGE SALES WHEN HIGH RATED PRODUCT AND LOW RATED PRODUCT COMPARISM--

select
    case 
       when Rating >= 4 then 'High Rated'
        else 'Low Rated'
   end AS RatingGiven,
   avg(sales) as AvgSales from ecommerce2 group by RatingGiven;
   
-- 22. RANKING PRODUCTS BY CATEGORY--

select ProductName, Rating, dense_rank() over ( order by Rating asc) as RatingRank from ecommerce2;

-- 23. TABLES TO BE UPDATED AUTOMATICALLY IF ANY UPDATES OR CHANGES DONE IN THE RAW DATA TABLE--

delimiter $$
create trigger new_insert
	after insert on ecommerce
    for each row
    begin
		insert into ecommerce2(ProductID, ProductName, Category, price, Rating, NumReviews, StockQuantity, discount, Sales, DateAdded)
        values (new.ProductID, new.ProductName, new.Category, new.price, new.Rating, new.NumReviews, new.StockQuantity, new.discount, new.Sales, new.DateAdded);
    end $$
    delimiter ;






