1) Find the artist who has contributed with the maximum no of albums. Display the artist name and the no of albums.

with cte as
	(select al.artistid, count(1) as total_album,
	rank() over(order by count(1) desc) as rnk
	from album al
	group by al.artistid)
select a.artistid, a.name, total_album
from artist a
join cte al on a.artistid = al.artistid
where rnk = 1

2) Display the name, email id, country of all listeners who love Jazz, Rock and Pop music.

select c.firstname|| ' ' || c.lastname as customer, c.email, c.country
from album al
join track t on t.albumid = al.albumid
join genre g on g.genreid = t.genreid
join invoiceline inl on inl.trackid = t.trackid
join invoice inv on inv.invoiceid = inl.invoiceid
join customer c on c.customerid = inv.customerid
where g.name in ('Jazz', 'Rock', 'Pop')

3) Find the employee who has supported the most no of customers. Display the employee name and designation

select employee_name, designation, no_of_support_provided, ranking from 
			(select (emp.firstname || ' ' || emp.lastname) as employee_name, cust.supportrepid, emp.title as designation, count(cust.supportrepid) as no_of_support_provided
			, rank() over(order by count(cust.supportrepid) desc) as ranking
			from employee emp
			join customer cust on emp.employeeid = cust.supportrepid
			group by cust.supportrepid, (emp.firstname || ' ' || emp.lastname), emp.title)
where ranking = 1

4) Which city corresponds to the best customers?

with cte as 
	(select billingcity, sum(total) as total_amount
	 , rank() over(order by sum(total) desc) as ranking_by_city_based_total_invoice_amount
	 from invoice inv
	 group by billingcity)
select billingcity
from cte
where ranking_by_city_based_total_invoice_amount = 1


5) The highest number of invoices belongs to which country?

with cte as 
	(select billingcountry, count(total) as total_count
	 , rank() over(order by sum(total) desc) as ranking_by_country_based_total_invoice_count
	 from invoice inv
	 group by billingcountry)
select billingcountry
from cte
where ranking_by_country_based_total_invoice_count = 1

6) Name the best customer (customer who spent the most money).

select * from
		(select cust.customerid, cust.firstname|| ' ' ||cust.lastname as cutomer_name, sum(inv.total) as total_spent
		, rank() over(order by sum(inv.total) desc) as ranking_based_on_spenting
		from customer cust 
		join invoice inv on inv.customerid = cust.customerid
		group by cust.customerid, cust.firstname|| ' ' ||cust.lastname)
where ranking_based_on_spenting = 1


7) Suppose you want to host a rock concert in a city and want to know which location should host it.

select * from
		(select inv.billingcity, count(1) as total_rocks_played
		,rank() over(order by count(1) desc) ranking_by_city
		from genre g
		join track t on g.genreid = t.genreid
		join invoiceline invl on invl.trackid = t.trackid
		join invoice inv on inv.invoiceid = invl.invoiceid
		where g.name = 'Rock'
		group by inv.billingcity)
where ranking_by_city = 1

8) Identify all the albums who have less then 5 track under them. Display the album name, artist name and the no of tracks in the respective album.

-- solution using cte 

with cte as
	(select t.albumid, count(1) no_of_tracks
	from track t
	group by t.albumid
	having count(1) < 5)
select (al.title) as album_name, (art.name) as artist_name
from cte 
join album al on al.albumid = cte.albumid
join artist art on art.artistid = al.artistid

-- solution using join	
select (a.title) as album_name, (art.name) as artist_name, count(t.trackid) as no_of_tracks
from album a 
join track t on t.albumid = a.albumid
join artist art on art.artistid = a.artistid
group by (a.title), (art.name) 
having count(t.trackid) < 5

9) Display the track, album, artist and the genre for all tracks which are not purchased.

select t.name as track_name, al.title as album_title, a.name as artist_name
from track t
join album al on al.albumid = t.albumid
join artist a on a.artistid = al.artistid
join genre g on g.genreid = t.genreid
where not exists (select t.trackid
				  from invoiceline inv
	              where inv.trackid = t.trackid)

10) Find artist who have performed in multiple genres. Diplay the aritst name and the genre.

with temp as
		(select distinct a.name as artist_name, g.name as genre
		from artist a
		join album al on a.artistid = al.artistid
		join track t on t.albumid = al.albumid
		join genre g on g.genreid = t.genreid),
	final_artist as
		(select artist_name
		from temp t
		group by artist_name
	    having count(1) > 1)
select t.*
from temp t
join final_artist fa on fa.artist_name = t.artist_name
order by 1,2;	

11) Which is the most popular and least popular genre?

with cte as		
		(select distinct g.name, count(1) as no_of_purchase
	    ,rank() over(order by count(1) desc) as ranking
		from track t 
		join invoiceline inv on t.trackid = inv.trackid
		join genre g on g.genreid = t.genreid
		group by g.name),
	temp as
		(select max(ranking) max_rank from cte)
select name as genre 
, case when ranking = 1 then 'Most_popular_genre' else 'Least_popular_genre' end as popularity
from cte 
cross join temp
where ranking = 1 or ranking = max_rank

12) Identify if there are tracks more expensive than others. If there are then display the track name along with the album title and artist 
    name for these expensive tracks.

select t.name as track_name, al.title as album_title, a.name as artist_name
from artist a
join album al on a.artistid = al.artistid
join track t on t.albumid = al.albumid
where unitprice > (select min(unitprice) from track)

13) Identify the 5 most popular artist for the most popular genre. Popularity is defined based on how many songs an artist has performed in for the particular genre.
    Display the artist name along with the no of songs.

with most_pop_genre as
					(select name as genre_title
					 from
						 (select g.name, count(1) as count_of_popular_genre
		                 ,rank() over(order by count(1) desc) as rnk_for_genre
						 from genre g
						 join track t on t.genreid = g.genreid
						 join invoiceline inv on inv.trackid = t.trackid
		                 group by g.name)
	                  where rnk_for_genre = 1),
	top_5_pop_artist as
					   (select a.name, count(1)as total_songs
						,rank() over(order by count(1) desc) as artist_ranking
						from artist a
						join album al on al.artistid = a.artistid
						join track t on t.albumid = al.albumid
						join genre g on g.genreid = t.genreid
						where g.name in(select genre_title from most_pop_genre)
						group by a.name)
select name, total_songs 
from top_5_pop_artist
where artist_ranking <=5
	
14) Find the artist who has contributed with the maximum no of songs/tracks. Display the artist name and the no of songs.

select * from		
		(select a.name, count(1) as total_songs
		, rank() over(order by count(1) desc) as rank
		from  artist a
		join album al on al.artistid = a.artistid
		join track t on t.albumid = al.albumid
		group by a.name)
where rank = 1

15) Are there any albums owned by multiple artist?

select a.albumid, count(1) total_albums
from album a
group by a.albumid
having count(1)>1

16) Is there any invoice which is issued to a non existing customer?

select * from Invoice I
where not exists (select 1 from customer c 
                  where c.customerid = I.customerid);

17) Is there any invoice line for a non existing invoice?

select * from InvoiceLine invl
where not exists (select 1 from Invoice I where I.invoiceid = invl.invoiceid);

	
select * from Album; 
select * from Artist; 
select * from Customer; 
select * from Employee; 
select * from Genre; 
select * from Invoice; 
select * from InvoiceLine; 
select * from MediaType; 
select * from Playlist; 
select * from PlaylistTrack; 
select * from Track; 
