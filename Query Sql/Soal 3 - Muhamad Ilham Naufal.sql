/*import csv to tabel sql*/
create table customer
(CustomerID int, FirstName varchar(50), LastName varchar(50), CustomerEmail varchar(200), 
CustomerPhone varchar(50), CustomerAddress varchar(150), CustomerCity varchar(50), CustomerState varchar(50),
CustomerZip int, Primary key (CustomerID));

create table orders 
(OrderID int, Date date,CustomerID int,ProdNumber varchar(10), quantity int);  

create table category 
(CategoryID int, CategoryName varchar(50), CategoryAbbreviation varchar(5) );

create table productcategory
(ProdNumber varchar(50), ProdName varchar(200),Category int, Price numeric(5,2));


/*Alter table add primary key and add foreign key*/
alter table orders add primary key (orderid);
alter table category add primary key (categoryid);
alter table productcategory add primary key (prodnumber);

alter table productcategory add constraint fk_category foreign key (category) references category (categoryid);
alter table orders add constraint fkcustomerid foreign key (customerid) references customer(customerid),
add constraint fkprodnumber foreign key (prodnumber) references productcategory(prodnumber);


/*View Table*/
select * from customer;
select * from orders ;
select * from category;
select * from productcategory;


/*CTE Master Data untuk analisis dan monitoring penjualan */
with masterdata as(
select o.date, o.orderid as order_id, o.customerid as customer_id, concat(c.firstname,' ',c.lastname) as name 
	,c.customeremail as email, o.prodnumber, pc.price, o.quantity, sum(pc.price * o.quantity) as Total
    from orders as o 
	left join customer as c on c.customerid=o.customerid
	left join productcategory as pc on pc.prodnumber=o.prodnumber
	group by 1,2,3,4,5,6,7,8
	order by date asc
)
select * from masterdata;

/*CTE Master Data2 untuk ditampilkan ke dashboard */
with masterdata2 as(
select o.date, o.orderid as order_id, o.customerid as customer_id, o.prodnumber, o.quantity, sum(pc.price * o.quantity) as Total,
	concat(c.firstname,' ',c.lastname) as name ,c.customeremail as email, c.customerphone as phone, 
	c.customeraddress as address, c.customerstate, c.customerzip,
	pc.prodname, pc.category,ca.categoryname, pc.price
    from orders as o 
	left join customer as c on c.customerid=o.customerid
	left join productcategory as pc on pc.prodnumber=o.prodnumber
	left join category as ca on ca.categoryid = pc.category
	group by 1,2,3,4,5,7,8,9,10,11,12,13,14,15,16
	order by date asc
)
select * from masterdata2;
