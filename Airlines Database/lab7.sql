create database AIRLINE;
use AIRLINE;

create table flights(flno int ,from_city varchar(20),to_city varchar(20),distance int,
departs time, arrives time ,price int );
create table aircraft(a_id int primary key ,a_name varchar(20),cruisingrange int );
create table employee(e_id int primary key ,e_name varchar(20),salary int); 
create table certified(e_id int,a_id int,
foreign key(a_id) references aircraft(a_id) on delete cascade,
foreign key(e_id) references employee(e_id) on delete cascade);

insert into flights(flno,from_city,to_city,distance,departs,arrives,price)values
(1,'BANGALORE','MANGALORE',360,'10:45:00','12:00:00',10000),
(2,'BANGALORE','DELHI',5000,'12:15:00','04:30:00',25000),
(3,'BANGALORE','MUMBAI',3500,'02:15:00','05:25:00',30000),
(4,'DELHI','MUMBAI',4500,'10:15:00','12:05:00',35000),
(5,'DELHI','FRANKFURT',18000,'07:15:00','05:30:00',90000),
(6,'Mumbai','Delhi',1200,'10:30:00','12:30:00',28000),
(7,'BANGALORE','FRANKFURT',17000,'12:00:00','06:30:00',99000),
(8,'MADISON','NEW YORK', 19000, '10:00:00', '17:00:00', 100000),
(9,'MADISON','NEW YORK', 29000, '10:00:00', '18:30:00', 100000),
(10,'MADISON','LONDON', 30000, '11:00:00', '14:00:00', 55000),
(12,'LONDON','NEW YORK', 30000, '14:05:00', '17:50:00', 50000),
(11,'LONDON','NEW YORK', 31000, '14:06:00', '18:05:00', 51000),
(12,'LONDON','BERLIN', 15000, '14:06:00', '16:05:00', 17000);
select * from flights;

insert into aircraft(a_id,a_name,cruisingrange)values
(111,'AIRBUS',1000),
(222,'BOEING',5000),
(333,'JET01',5000),
(444,'DOUGLAS',8000),
(555,'ANTONOV',500),
(666,'VICKERS',800),
(777,'FOKKER',1000);
select * from aircraft;

insert into employee(e_id,e_name,salary)values (10,'DANNY',80000),
(1,'ARJUN',30000),
(2,'ARPITH',85000),
(3,'BHOOMI',50000),
(4,'HENRY',45000),
(5,'JOMIE',90000),
(6,'ANOSH',75000),
(7,'RICK',100000),
(8,'JANE',70000),
(9,'SOFIE',80000);
select * from employee;

insert into certified(e_id,a_id) values (9,222),
(1,111),
(2,777),
(2,333),
(3,555),
(4,222),
(5,666),
(5,222),
(6,333),
(6,111),
(7,111),
(8,444),
(9,555),
(9,333);
select * from certified;


-- i. Find the names of aircraft such that all pilots certified to 
-- operate them have salaries more than Rs.80,000.
select distinct a.a_name from aircraft a,certified c,employee e
where a.a_id=c.a_id and c.e_id=e.e_id and e.salary>80000;

-- ii. For each pilot who is certified for more than three aircrafts, find the
--  eid and the maximum cruising range of the aircraft for which she or he is certified.
select e.e_id,max(a.cruisingrange) from aircraft a,employee e,certified c 
where a.a_id=c.a_id and e.e_id=c.e_id group by e.e_id having count(e.e_id)>3;

-- iii. Find the names of pilots whose salary is less than the price of the 
-- cheapest route from Bengaluru to Frankfurt.
select e.e_name from employee e where e.e_id in(select e_id from certified)
and salary<(select min(price) from flights where from_city="BANGALORE" and 
to_city="FRANKFURT");

-- iv. For all aircraft with cruising range over 1000 Kms, find the name of the 
-- aircraft and the average salary of all pilots certified for this aircraft.
select a.a_name,avg(e.salary) from aircraft a,employee e,certified c 
where a.a_id=c.a_id and e.e_id=c.e_id and a.cruisingrange>1000 group by a.a_name;

-- v. Find the names of pilots certified for some Boeing aircraft.
select e.e_name from aircraft a,employee e,certified c 
where a.a_id=c.a_id and e.e_id=c.e_id and a.a_name="BOEING";

-- vi. Find the aids of all aircraft that can be used on
--  routes from Bengaluru to New Delhi.
select a_id from aircraft where cruisingrange>=(select distance from flights 
where from_city="BANGALORE" and to_city="DELHI");

-- vii. A customer wants to travel from Madison to New York with no
--  more than two changes of flight. List the choice of departure times 
-- from Madison if the customer wants to arrive in New York by 6 p.m.
select f.flno ,f.departs from flights f where f.flno in ( ( select f1.flno 
from flights f1 where f1.from_city="MADISON" AND f1.to_city="NEW YORK" and f1.arrives<'18:00:00')
union ( select f1.flno from flights f1,flights f2 where f1.from_city="MADISON" 
and f1.to_city!="NEW YORK" and f1.to_city=f2.from_city and f2.to_city="NEW YORK"
and f2.departs>f1.arrives and f2.arrives<'18:00:00'));

-- viii. Print the name and salary of every non-pilot whose
-- salary is more than the average salary for pilots.
select e_name from employee where e_id not in(select e_id from certified) 
and salary>(select avg(salary) from employee where e_id in(select e_id from certified));
 