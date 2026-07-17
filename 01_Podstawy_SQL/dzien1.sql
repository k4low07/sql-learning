USE sakila;

SELECT *
FROM film
WHERE length > 60
  AND rating = 'NC-17';

-- FILTROWANIE --> WYPOŻYCZENIA
-- ad1
SELECT *
FROM rental
WHERE rental_date LIKE '2005%';

-- ad2
SELECT *
FROM rental
WHERE rental_date LIKE '2005-05-24%';
-- ad3
SELECT *
FROM rental
WHERE rental_date >= '2005-07-01';
-- ad4
SELECT *
FROM staff;

SELECT *
FROM rental
WHERE rental_date BETWEEN '2005-06-30' AND '2005-09-01'
  AND staff_id = 2;

-- ctrl + alt + l formatowanie
-- FILTROWANIE --> klienci

-- ad1
SELECT *
FROM customer
WHERE active = 1;

-- ad2
SELECT *
FROM customer
WHERE active = 1
          XOR first_name LIKE 'ANDRE%';

-- FILTROWANIE --> klienci cz.2
-- ad1
SELECT *
FROM customer
WHERE active = 0
  AND store_id = 1;

-- ad2
SELECT *
FROM customer
WHERE email NOT LIKE '%sakilacustomer.org';

-- ad3
SELECT DISTINCT create_date
FROM customer;

SELECT *
FROM customer
ORDER BY create_date DESC;

SELECT create_date, GROUP_CONCAT(first_name ORDER BY first_name SEPARATOR ',') AS all_names
FROM customer
GROUP BY create_date;

-- filtrowanie --> aktorzy

SHOW FULL TABLES IN sakila WHERE TABLE_TYPE = 'VIEW';


-- Create view as actor_analytics

DROP VIEW IF EXISTS actor_analytics;

CREATE VIEW actor_analytics AS
SELECT a.actor_id,
       a.first_name,
       a.last_name,

       COUNT(DISTINCT f.film_id)          AS films_amount,

       ROUND(
               AVG(
                       CASE f.rating
                           WHEN 'G' THEN 1
                           WHEN 'PG' THEN 2
                           WHEN 'PG-13' THEN 3
                           WHEN 'R' THEN 4
                           WHEN 'NC-17' THEN 5
                           END
               ),
               2
       )                                  AS avg_film_rate,

       MAX(f.length)                      AS longest_movie_duration,

       ROUND(IFNULL(SUM(p.amount), 0), 2) AS actor_payload

FROM actor a
         LEFT JOIN film_actor fa
                   ON a.actor_id = fa.actor_id
         LEFT JOIN film f
                   ON fa.film_id = f.film_id
         LEFT JOIN inventory i
                   ON f.film_id = i.film_id
         LEFT JOIN rental r
                   ON i.inventory_id = r.inventory_id
         LEFT JOIN payment p
                   ON r.rental_id = p.rental_id

GROUP BY a.actor_id,
         a.first_name,
         a.last_name;

-- ad1
SELECT *
FROM actor_analytics
WHERE films_amount > 25
ORDER BY films_amount DESC;

-- ad2
SELECT *
FROM actor_analytics
WHERE films_amount > 20
  AND avg_film_rate > 3.3
ORDER BY avg_film_rate;

-- ad3
SELECT *
FROM actor_analytics
WHERE films_amount > 20
    AND avg_film_rate > 3.3
   OR actor_payload > 2000;

-- FORMATOWANIE DANYCH WYJŚCIOWYCH

SELECT actor_id AS ID, last_name AS nazwisko
FROM actor;

SELECT last_update,
       DATE_FORMAT(last_update, '%d-%m-%Y') AS date_formatted
FROM actor;



