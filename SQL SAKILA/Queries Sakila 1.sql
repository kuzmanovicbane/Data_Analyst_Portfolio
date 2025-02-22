### Find the top 3 actors by total rental revenue only if payment amount is more then 2.
WITH actor_revenue AS (
	SELECT CONCAT(a.first_name,' ',a.last_name) AS Full_Name, SUM(p.amount) AS Total_Amount
    FROM actor a
    JOIN film_actor fa ON a.actor_ID = fa.actor_ID
    JOIN inventory i ON fa.film_id = i.film_id
    JOIN rental r ON i.inventory_ID = r.inventory_ID
    JOIN payment p ON r.rental_ID = p.rental_ID
    WHERE p.amount > 2
    GROUP BY a.actor_id
)	
SELECT Full_Name, Total_Amount
FROM actor_revenue
ORDER BY Total_Amount DESC
LIMIT 3;

### Find the most popular renting film genres in the last 3 months	

WITH genre_rentals AS (
    SELECT c.name AS genre, COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
     WHERE r.rental_date >= (
        SELECT MAX(rental_date) FROM rental
    ) - INTERVAL 3 MONTH
    GROUP BY c.name
)
SELECT genre, rental_count
FROM genre_rentals
ORDER BY rental_count DESC;

### Find the most popular renting film genres and divide them in categories: above average, average, below average

WITH genre_rentals AS (
    SELECT 
        c.name AS genre, 
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name
),
average_rental AS (
    SELECT AVG(rental_count) AS avg_rental
    FROM genre_rentals 
)
SELECT 
    gr.genre,
    gr.rental_count,
    ar.avg_rental,
    CASE 
        WHEN gr.rental_count > ar.avg_rental THEN 'Above Average'
        WHEN gr.rental_count = ar.avg_rental THEN 'Average'
        WHEN gr.rental_count < ar.avg_rental THEN 'Below Average'
    END AS rental_count_category
FROM genre_rentals gr, average_rental ar
ORDER BY gr.rental_count DESC;

### Find the average rental duration per customer and rank them

WITH avg_rental_duration_per_cust AS (
	SELECT CONCAT(c.first_name,' ',c.last_name) AS Full_Name, AVG(DATEDIFF(r.return_date, r.rental_date)) AS Average_rental_days
    FROM rental r 
    JOIN customer c ON r.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
	avgrentdur.Full_Name, 
    avgrentdur.Average_rental_days,
    RANK() OVER(ORDER BY avgrentdur.Average_rental_days DESC) AS Rental_Rank
FROM avg_rental_duration_per_cust avgrentdur
ORDER BY Rental_Rank;

#### Get the list of employees and their performance (number of rentals processed) in the last month

WITH latest_rental_date AS (
    SELECT MAX(rental_date) AS max_rental_date
    FROM rental
),
employees_rentals AS (
    SELECT 
        CONCAT(s.first_name, ' ', s.last_name) AS Full_Staff_Name, 
        COUNT(r.rental_id) AS Count_Of_Rentals
    FROM rental r
    JOIN staff s ON r.staff_id = s.staff_id
    JOIN latest_rental_date lrd
    WHERE r.rental_date >= lrd.max_rental_date - INTERVAL 1 MONTH
    GROUP BY s.staff_id
)
SELECT *
FROM employees_rentals
ORDER BY Count_Of_Rentals DESC;




    


    
    