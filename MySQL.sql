-- List all movies that have a title that starts with ‘Cat’, with year in date order
select title, yr from movie where title like 'Cat%'
order by yr;

-- How many Star Trek movies came out by decade (1970-79, 1980-89, 1990-99, 2000-09).
-- Group bye decade using case statements. Include the average budget and average gross
-- revenue for the films in each decade.

select t.decade, count(t.title) as cnt, avg(t.budget), avg(t.gross)
from (select title, yr, budget, gross,
case 
	when yr between 1970 and 1979 Then "1970-79"
    when yr between 1980 and 1989 Then "1980-89"
    when yr between 1990 and 1999 Then "1990-99"
    when yr between 2000 and 2009 Then "2000-09"
    when yr between 2010 and 2019 Then "2009-19"
    end  as Decade
    from movie
    where title like 'Star Trek%') T
group by t.decade
order by decade;

-- What are the top 5 grossing movies in the database? What year did they come out and who
-- were the lead actors?
   
   select title, yr, gross, a.name
   from movie m
    join casting c on c.movieid=m.id
    join actor a on c.actorid=a.id
   where c.ord=1
   order by gross desc
   limit 5;
    
-- List all movies (titles and yr) in which Harrison Ford acted in, but was not the lead actor.

select title, yr
   from movie m
    where m.id in
    (select c.movieid from casting c join actor a on c.actorid=a.id
			where c.ord > 0 and a.name = 'Harrison Ford')
order by yr;

-- In what years did Glenn Close make more than 1 movie? How many movies did she make in
-- each of those years? And what was the total gross revenue of her movies in those years?

select  yr, count(title) as cnt, sum(gross) as total
from movie
where id in
    (select c.movieid from casting c join actor a on c.actorid=a.id
			where a.name = 'Glenn Close')
group by yr
having count(title) > 1
order by yr;

-- How many unique actors/actresses have worked in a movie with Carrie Fisher. Hint: make
-- sure your list doesn’t have any duplicates.

Select Count(name) as cnt
from actor
where id in
	(Select distinct actorid
	from casting where movieid in
		(select c.movieid from casting c join actor a on c.actorid=a.id
				where a.name = 'Carrie Fisher')
	) and name <> 'Carrie Fisher';

-- Which director has the most movies that came ahead of budget (gross > budget)?

select name from actor
where id = 
(select director
from movie
where (gross-budget) > 0
group by director
order by Count(title) desc
limit 1);

-- Who is Director Steven Spielberg’s favourite actor, i.e., which actor has appeared in the
-- most films of Steven Spielberg’s?

select name from actor
where id = 
	(Select actorid from casting
	where movieid in
		(select id from movie
			where director = (select id from actor where name= 'Steven Spielberg'))
	group by actorid
	order by Count(actorid) desc
	limit 1);
    
    

-- Which Lord of the Rings had a different director from the others? Who is that director?
Select title, 
(select a.name from actor a where a.id=director) as "Director Name"
from movie
where title like 'The Lord of the Rings%'
group by director
having count(title) = 1

-- What director and actor pair have worked together most in movies? Find the actor who
-- worked in the most movies of any director. Note: this is a tricky question.


