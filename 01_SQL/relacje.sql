USE sakila;

SELECT *
FROM film
WHERE length > 60
  AND rating = 'NC-17';

-- FILTERING --> RENTALS FROM 2005
--
SELECT *
FROM rental
WHERE rental_date LIKE '2005%';

-- RENTALS FROM 2005-05-24
SELECT *
FROM rental
WHERE rental_date LIKE '2005-05-24%';
-- ABOUT RENTALS AFTER 2005-06-30
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

-- SHOW FULL TABLES IN sakila WHERE TABLE_TYPE = 'VIEW';


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

SELECT last_update,
       DATE_FORMAT(last_update, GET_FORMAT(DATE, 'USA')) AS date_formatted
FROM actor;


-- aliasing

SELECT rental_id,
       inventory_id,
       customer_id,
       rental_date AS date_of_rental,
       return_date AS date_of_rental_return
FROM rental;

SELECT rental_id    AS id_wypożyczenia,
       inventory_id AS id_przedmiotu,
       rental_date  AS data_wypożyczenia,
       return_date  AS data_zwrotu
FROM rental;

-- date formatting

SELECT payment_date,
       DATE_FORMAT(payment_date, '%Y-%m-%d')              AS date_formatted,
       DATE_FORMAT(payment_date, '%Y-%M-%W')              AS date_formatted_2,
       DATE_FORMAT(payment_date, '%Y-%u')                 AS date_formatted_3,
       DATE_FORMAT(payment_date, '%Y/%m/%d@%W')           AS date_formatted_4,
       DATE_FORMAT(payment_date, '%Y/%m/%d@%u')           AS date_formatted_5,
       DATE_FORMAT(payment_date, GET_FORMAT(DATE, 'USA')) AS payment_date_usa_formatted
FROM payment;

-- LEAST

SELECT price,
       length,
       LEAST(price, length) AS najniższa
FROM film_list;


SELECT price,
       length,
       rating,
       LEAST(price, length, rating) AS najniższa
FROM film_list;

-- GREATEST

SELECT price,
       length,
       GREATEST(price, length)
FROM film_list;

SELECT price,
       length,
       rating,
       GREATEST(price, length, rating) AS największa
FROM film_list;

-- UNION

SELECT first_name, 'actor' AS category
FROM actor
UNION
SELECT first_name, 'staff' AS category
FROM staff
ORDER BY first_name;

SELECT first_name, 'actor' AS category
FROM actor
UNION ALL
SELECT first_name, 'staff' AS category
FROM staff
ORDER BY first_name;


SELECT first_name, 'customer' AS category
FROM actor
UNION
SELECT first_name, 'actor' AS category
FROM customer
UNION
SELECT first_name, 'staff' AS category
FROM staff;

-- without using DISTINCT
SELECT category
FROM nicer_but_slower_film_list
UNION
SELECT category
FROM nicer_but_slower_film_list;

-- CREATE VIEW
DROP VIEW IF EXISTS sales_total;

CREATE VIEW sales_total AS
SELECT ROUND(SUM(amount), 2) AS total_sales
FROM payment;

DROP VIEW IF EXISTS rating_analytics;

CREATE VIEW rating_analytics AS
SELECT rating,
       AVG(rental_duration) AS avg_rental_duration,
       AVG(rental_rate)     AS avg_rental_rate,
       COUNT(*)             AS rentals,
       AVG(length)          AS avg_film_length
FROM film
GROUP BY rating
WITH ROLLUP;

DROP VIEW IF EXISTS rating;

CREATE VIEW rating AS
SELECT ROW_NUMBER() OVER (ORDER BY rating) AS id_rating,
       rating
FROM (SELECT DISTINCT rating
      FROM film) AS r;


DROP VIEW IF EXISTS film_list;

CREATE VIEW film_list AS
SELECT f.film_id     AS FID,
       f.title,
       f.description,
       c.name        AS category,
       f.rental_rate AS price,
       f.length,
       f.rating,
       GROUP_CONCAT(
               CONCAT(a.first_name, ' ', a.last_name)
               ORDER BY a.last_name, a.first_name
               SEPARATOR ', '
       )             AS actors
FROM film AS f
         JOIN film_category AS fc
              ON f.film_id = fc.film_id
         JOIN category AS c
              ON fc.category_id = c.category_id
         JOIN film_actor AS fa
              ON f.film_id = fa.film_id
         JOIN actor AS a
              ON fa.actor_id = a.actor_id
GROUP BY f.film_id,
         f.title,
         f.description,
         c.name,
         f.rental_rate,
         f.length,
         f.rating;

-- PODZAPYTANIA

SELECT *
FROM sales_by_store
WHERE (sales_by_store.total_sales / (SELECT sales_total.total_sales FROM sales_total)) > 0.5;

SELECT store
FROM sales_by_store
WHERE total_sales > (SELECT 0.5 * total_sales AS half_of_total_sales FROM sales_total);

SELECT *
FROM rating_analytics;

SELECT rating_analytics.avg_rental_rate
FROM rating_analytics
WHERE rating IS NULL;

SELECT rating, avg_rental_rate
FROM rating_analytics
WHERE avg_rental_rate > (SELECT avg_rental_rate
                         FROM rating_analytics
                         WHERE rating IS NULL);


WITH total AS (SELECT avg_rental_rate
               FROM rating_analytics
               WHERE rating IS NULL)
SELECT rating, avg_rental_rate
FROM rating_analytics
WHERE avg_rental_rate > (SELECT avg_rental_rate
                         FROM total);

SELECT rating, avg_rental_duration
FROM rating_analytics
WHERE avg_rental_duration < (SELECT avg_rental_duration
                             FROM rating_analytics
                             WHERE rating IS NULL);


WITH x AS (SELECT avg_rental_duration
           FROM rating_analytics
           WHERE rating IS NULL)
SELECT *
FROM rating_analytics
WHERE avg_rental_duration < (SELECT avg_rental_duration
                             FROM x);

SELECT *
FROM rating_analytics
WHERE rating = (SELECT rating
                FROM rating
                WHERE id_rating = 3);

SELECT *
FROM rating_analytics
WHERE rating IN (SELECT rating FROM rating WHERE id_rating IN (3, 2, 5));

SELECT rating, rentals
FROM rating_analytics
WHERE rating IS NOT NULL
ORDER BY rentals DESC
LIMIT 1;

SELECT *
FROM rating_analytics
WHERE rentals = (SELECT MAX(rentals) FROM rating_analytics WHERE rating IS NOT NULL);

SELECT *
FROM rating_analytics
WHERE rating IS NOT NULL
ORDER BY rentals DESC
LIMIT 1;

SELECT rating, avg_film_length
FROM rating_analytics
WHERE rating IS NOT NULL
ORDER BY avg_film_length
LIMIT 1;

SELECT *
FROM actor_analytics
WHERE actor_id = (SELECT actor_id
                  FROM actor
                  WHERE first_name = 'ZERO'
                    AND last_name = 'CAGE');

SELECT *
FROM actor_analytics
WHERE films_amount >= 30
ORDER BY films_amount DESC;

SELECT *
FROM actor
WHERE actor_id IN (SELECT actor_id FROM actor_analytics WHERE films_amount >= 30);

SELECT *
FROM actor
WHERE actor_id IN (SELECT actor_id FROM actor_analytics WHERE films_amount >= 30 ORDER BY films_amount DESC);


SELECT *
FROM actor
WHERE actor_id IN (SELECT actor_id
                   FROM actor_analytics
                   WHERE films_amount >= 30)
ORDER BY (SELECT films_amount
          FROM actor_analytics
          WHERE actor_analytics.actor_id = actor.actor_id) DESC;


SELECT *
FROM actor_analytics;

SELECT *
FROM actor
WHERE actor_id IN (SELECT actor_id FROM actor_analytics WHERE longest_movie_duration IN (184, 174, 176, 164));


SELECT actor_id
FROM actor_analytics
WHERE longest_movie_duration IN (184, 174, 176, 164);


SELECT film_id
FROM film_actor
WHERE actor_id IN (SELECT actor_id FROM actor_analytics WHERE longest_movie_duration IN (184, 174, 176, 164));


SELECT *
FROM film
WHERE film_id IN (SELECT film_id
                  FROM film_actor
                  WHERE actor_id IN (SELECT actor_id
                                     FROM actor_analytics
                                     WHERE longest_movie_duration IN (184, 174, 176, 164)));



SELECT *
FROM film_list
WHERE category IN ('Horror', 'Documentary', 'Family')
  AND (rating IN ('R') OR rating IN ('NC-17'));


SELECT description
FROM film_text
WHERE film_id IN (SELECT FID
                  FROM film_list
                  WHERE category IN ('Horror', 'Documentary', 'Family')
                    AND (rating IN ('R') OR rating IN ('NC-17')));

SELECT *
FROM film_list
WHERE category IN ('Horror', 'Documentary', 'Family')
  AND (rating IN ('R') OR rating IN ('NC-17'))
ORDER BY category, price DESC;

SELECT *
FROM film_list
WHERE category IN ('Horror', 'Documentary', 'Family')
  AND (rating IN ('R') OR rating IN ('NC-17'))
ORDER BY rating, length DESC;

