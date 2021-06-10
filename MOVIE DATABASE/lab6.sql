CREATE DATABASE MOVIE;
USE MOVIE;

CREATE TABLE ACTOR(ACT_ID INT PRIMARY KEY ,ACT_NAME VARCHAR(30),ACT_GENDER VARCHAR(30)  );

CREATE TABLE DIRECTOR(DIR_ID INT,DIR_NAME VARCHAR(30),PHONE_NO LONG,PRIMARY KEY(DIR_ID));

CREATE TABLE MOVIES(MOVIE_ID INT,MOVIE_TITLE VARCHAR(30),MOVIE_YEAR INT,MOVIE_LANG VARCHAR(30),DIR_ID INT,
    PRIMARY KEY(MOVIE_ID),
	FOREIGN KEY(DIR_ID) REFERENCES DIRECTOR(DIR_ID) ON UPDATE CASCADE);
                  
CREATE TABLE MOVIE_CAST(ACT_ID INT,MOVIE_ID INT,ROLE VARCHAR(30),
	FOREIGN KEY(ACT_ID) REFERENCES ACTOR(ACT_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(MOVIE_ID) REFERENCES MOVIES(MOVIE_ID) ON DELETE CASCADE ON UPDATE CASCADE);
    
CREATE TABLE RATING(MOVIE_ID INT,RATING_STARS INT CHECK (RATING_STARS<=5),
	FOREIGN KEY(MOVIE_ID) REFERENCES MOVIES(MOVIE_ID) ON UPDATE CASCADE);


INSERT INTO ACTOR(ACT_ID,ACT_NAME,ACT_GENDER) VALUES 
(1, 'Tom Cruise','MALE' ),
(2, 'Leonardo','MALE'),
(3, 'Robert Downey', 'MALE'),
 (4, 'Jennifer Lawrence','FEMALE'),
(5, 'Emma Stone','FEMALE');	
select * from ACTOR;
                                                     
INSERT INTO DIRECTOR(DIR_ID, DIR_NAME, PHONE_NO) VALUES 
(1, 'Steven Spielberg', 99988776600),  
(2, 'Christopher', 9988776611),   
(3, 'Alfred Hitchcock', 9988776622),   
(4, 'Tim Burton', 9988776633),   
(5, 'James Cameron', 9988776644);
select * from DIRECTOR;
INSERT INTO MOVIES(MOVIE_ID,MOVIE_TITLE,MOVIE_YEAR,MOVIE_LANG,DIR_ID) VALUES
(1,'War of the Worlds', 2005, 'ENG', 1),
(2,'Titanic', 1997, 'ENG', 1),
(3,'Iron Man', 2008, 'ENG', 2),
(4,'Red Sparrow', 2018, 'ENG', 3),
(5,'Spider Man',2015, 'ENG', 4),
(6, 'Avatar', 2009, 'ENG', 5),
(7,'Mission Impossible',2017,'ENG',3);
select * from MOVIES;

INSERT INTO MOVIE_CAST(ACT_ID, MOVIE_ID,ROLE) VALUES
(1, 1, 'LEAD'),		
(1, 7, 'LEAD'),	
(2, 2, 'LEAD'),	
(3, 3, 'LEAD'),	
(4, 4, 'LEAD'),	
(5, 5, 'LEAD'),
 (5,6,'CO-STAR');   
 select * FROM MOVIE_CAST;
                                                    
INSERT INTO RATING(MOVIE_ID, RATING_STARS) VALUES
(1, 3),
(2, 4),
(3, 5),
(4, 3),
(5, 4),
(6, 4),
(7, 5);

SELECT * FROM RATING;  

                                              
-- 3. List the titles of all movies directed by ‘Hitchcock’.
SELECT M.MOVIE_TITLE FROM MOVIES M,DIRECTOR D WHERE M.DIR_ID=D.DIR_ID 
AND D.DIR_NAME='Alfred Hitchcock';

-- 4. Find the movie names where one or more actors acted in two or more movies.
SELECT M.MOVIE_TITLE FROM ACTOR A,MOVIE_CAST C,MOVIES M WHERE A.ACT_ID=C.ACT_ID AND 
C.MOVIE_ID=M.MOVIE_ID AND A.ACT_ID IN(SELECT ACT_ID FROM MOVIE_CAST GROUP BY ACT_ID HAVING COUNT(*)>=2);    

-- 5. List all actors who acted in a movie before 2000 and also in a movie after 2015 (use JOIN operation).
SELECT A.ACT_NAME FROM ACTOR A 
JOIN MOVIE_CAST MC ON A.ACT_ID=MC.ACT_ID
JOIN MOVIES M ON MC.MOVIE_ID=M.MOVIE_ID 
WHERE M.MOVIE_YEAR NOT BETWEEN 2000 AND 2015;

-- 6. Find the title of movies and number of stars for each movie that has at least one rating and find the highest
-- number of stars that movie received. Sort the result by movie title.
SELECT M.MOVIE_TITLE, MAX(R.RATING_STARS) AS MAXIMUM_RATING FROM MOVIES M, RATING R 
WHERE M.MOVIE_ID = R.MOVIE_ID GROUP BY M.MOVIE_TITLE HAVING COUNT(R.RATING_STARS>=1) ORDER BY M.MOVIE_TITLE;
 
 
-- 7. Update rating of all movies directed by ‘Steven Spielberg’ to 5. 
UPDATE RATING SET RATING_STARS = 5 WHERE MOVIE_ID IN
(SELECT M.MOVIE_ID FROM MOVIES M, DIRECTOR D WHERE M.DIR_ID = D.DIR_ID 
AND D.DIR_NAME='Steven Spielberg');      
SELECT * FROM RATING;  