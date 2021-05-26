create database Student_Enrollment;
use Student_enrollment;
create table student(regno varchar(10) primary key,name varchar(10),major varchar(10),bdate date);
create table course(course_no int primary key,cname varchar(10),dept varchar(10));
create table enroll(regno varchar(10),course_no int,sem int, marks int,
foreign key(regno) references student(regno) on delete cascade,
foreign key(course_no) references course(course_no) on delete cascade);
create table text_book(book_isbn int primary key,book_title varchar(20),publisher varchar(10),author varchar(10));
create table book_adoption(course_no int,sem int,book_isbn int ,
foreign key(course_no) references course(course_no) on delete cascade,
foreign key(book_isbn) references text_book(book_isbn) on delete cascade);

insert into student(regno,name,major,bdate) values
("cs01","ram","ds",'1986-03-12'),
("is02","smith","usp",'1987-12-23'),
("ec03","ahmed","sns",'1985-04-17'),
("cs03","sneha","dbms",'1987-01-01'),
("tc05","akhila","ec",'1986-10-06');
select * from student;

insert into course(course_no,cname,dept) values
(11,"ds","cs"),
(22,"usp","is"),
(33,"sns","ec"),
(44,"dbms","cs"),
(55,"ec","tc");
select * from course;

insert into enroll(regno,course_no,sem,marks) values
("cs01",11,4,85),
("is02",22,6,80),
("ec03",33,2,80),
("cs03",44,6,75),
("tc05",55,2,80);
select * from enroll;

insert into text_book(book_isbn,book_title,publisher,author) values
(1,"ds and c","princeton","padma"),
(2,"fundamentals of ds","princeton","godse"),
(3,"fundamentals of dbms","princeton","navathe"),
(4,"sql","princeton","foley"),
(5,"electronic circuits","tmh","elmarsi"),
(6,"adv unix program","tmh","stevens");
select * from text_book;

insert into book_adoption(course_no,sem,book_isbn) values
(11,4,1),(11,4,2),(44,6,3),(44,6,4),(55,2,5),(22,6,6);
select * from book_adoption;

-- Demonstrate how you add a new text book to the database and make this book be adopted by some department.
insert into text_book values(7,"database basics","princeton","shawn");
insert into book_adoption values(11,4,7);

-- Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical order
 -- for courses offered by the ‘CS’ department that use more than two books.
select c.course_no,t.book_isbn,t.book_title from course c, text_book t,book_adoption b 
where t.book_isbn=b.book_isbn and b.course_no=c.course_no and c.dept="cs" and
 (select count(b.book_isbn) from book_adoption b where c.course_no=b.course_no)>2 order by t.book_title;

-- List any department that has all its adopted books published by a specific publisher.
select distinct c.dept from course c where c.dept in (select c.dept 
from course c,book_adoption b,text_book t where c.course_no=b.course_no
and t.book_isbn=b.book_isbn and t.publisher="tmh") 
and c.dept not in (select c.dept 
from course c,book_adoption b,text_book t where c.course_no=b.course_no
and t.book_isbn=b.book_isbn and t.publisher!="tmh") ;
