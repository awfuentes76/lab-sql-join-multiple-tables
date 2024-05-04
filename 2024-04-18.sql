-- Lab | SQL Joins on multiple tables
-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions
-- Write a query to display for each store its store ID, city, and country.

SELECT store_id, city, country
FROM store AS st
LEFT JOIN address AS ad
ON st.address_id = ad.address_id
LEFT JOIN city AS ci
ON ad.city_id = ci.city_id
LEFT JOIN country AS co
ON ci.country_id = co.country_id;

-- Write a query to display how much business, in dollars, each store brought in.

SELECT st.store_id, pa.amount
FROM store AS st
LEFT JOIN staff AS sta
ON st.address_id = sta.address_id
LEFT JOIN payment AS pa
ON sta.staff_id = pa.staff_id
;

SELECT rental_id, COUNT(DISTINCT staff_id) FROM payment
group by rental_id
HAVING COUNT(DISTINCT staff_id)>1;

-- esta es la buena:

SELECT st.store_id, SUM(pa.amount)
FROM payment AS pa
LEFT JOIN staff AS st
ON pa.staff_id = st.staff_id
GROUP BY st.store_id;

SELECT * FROM store;

-- What is the average running time of films by category?

SELECT ca.category_id, AVG(fi.length)
FROM film AS fi
LEFT JOIN film_category AS ca
ON fi.film_id = ca.film_id
GROUP BY ca.category_id;

-- Which film categories are longest?

SELECT ca.category_id, AVG(fi.length)
FROM film AS fi
LEFT JOIN film_category AS ca
ON fi.film_id = ca.film_id
GROUP BY ca.category_id
ORDER BY AVG(fi.length) DESC;


-- Display the most frequently rented movies in descending order.

SELECT fi.title, COUNT(re.rental_id) AS cantidad_alquileres
FROM film AS fi
LEFT JOIN inventory AS inv
ON fi.film_id = inv.film_id
LEFT JOIN rental AS re
ON inv.inventory_id = re.inventory_id
GROUP BY title
ORDER BY cantidad_alquileres DESC;

-- List the top five genres in gross revenue in descending order.

SELECT ca.name, SUM(pa.amount) AS gross_revenue
FROM category AS ca
INNER JOIN film_category fc
ON ca.category_id = fc.category_id
INNER JOIN film fi
ON fi.film_id = fc.film_id
INNER JOIN inventory inv
ON inv.film_id = fi.film_id
INNER JOIN rental re
ON re.inventory_id = inv.inventory_id
INNER JOIN payment pa
ON pa.rental_id = re.rental_id
GROUP BY name
ORDER BY gross_revenue DESC;


-- Is "Academy Dinosaur" available for rent from Store 1?

SELECT fi.title, inv.store_id
FROM film AS fi
INNER JOIN inventory inv
ON fi.film_id = inv.film_id
WHERE store_id=1 AND fi.title="Academy Dinosaur";

SELECT 
    f.title,
    i.store_id,
    IF(COUNT(r.rental_id) = SUM(r.return_date IS NOT NULL), 'Available', 'Not Available') AS availability_status
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    f.title = 'Academy Dinosaur' AND
    i.store_id = 1
GROUP BY 
    f.title, i.store_id;


