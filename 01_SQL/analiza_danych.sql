SELECT COUNT(DISTINCT customer_id) AS rows_amount
FROM payment;

SELECT customer_id
FROM payment;

SELECT actor_id, COUNT(film_id) AS played_in
FROM film_actor
GROUP BY actor_id;

SELECT staff_id, SUM(amount) AS suma
FROM payment
GROUP BY staff_id;

SELECT a.first_name   AS actor_name,
       a.last_name    AS actor_last_name,
       COUNT(film_id) AS played_in
FROM film_actor AS fa
         INNER JOIN actor AS a
                    USING (actor_id)
GROUP BY actor_id
ORDER BY played_in DESC;

SELECT customer_id,
       SUM(amount) AS total_amount
FROM payment
WHERE amount > 1
GROUP BY customer_id
HAVING total_amount > 100;

SELECT SUM(amount) AS total_amount
FROM payment;

SELECT customer_id,
       SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC;

SELECT staff_id,
       SUM(amount) AS total_amount
FROM payment
GROUP BY staff_id
ORDER BY total_amount DESC;

SELECT DATE_FORMAT('2026-03-01 23:59:23', '%Y-%m');

SELECT customer_id,
       DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
       SUM(amount)                        AS total_amount
FROM payment
GROUP BY customer_id, payment_month
ORDER BY customer_id, total_amount DESC;



SELECT staff_id,
       DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
       SUM(amount)                        AS total_amount
FROM payment
GROUP BY staff_id, payment_month
ORDER BY staff_id, total_amount DESC;

CREATE OR REPLACE VIEW payment_per_customer AS
SELECT c.first_name,
       c.last_name,
       c.email,
       SUM(p.amount)       AS customer_amount,
       COUNT(*)            AS payment_count,
       AVG(p.amount)       AS avg_payment,
       MAX(p.payment_date) AS max_date
FROM payment AS p
         JOIN customer AS c USING (customer_id)
GROUP BY customer_id;

SELECT *
FROM payment_per_customer;
DROP TABLE IF EXISTS tmp_film_actors;
CREATE TEMPORARY TABLE tmp_film_actors AS
SELECT f.film_id,
       f.title,
       COUNT(*) AS count_actors
FROM film AS f
         JOIN film_actor AS fa USING (film_id)
GROUP BY film_id;

SELECT *
FROM tmp_film_actors;

SELECT f.film_id, f.title
FROM film AS f
         LEFT JOIN film_actor AS fa USING (film_id)
WHERE actor_id IS NULL;

SELECT COUNT(*) AS film_witout_actor
FROM film AS f
         LEFT JOIN film_actor AS fa USING (film_id)
WHERE fa.actor_id IS NULL;

SELECT *
FROM film
WHERE film_id NOT IN (SELECT film_id FROM film_actor);

SELECT SUM(count_actors)
FROM tmp_film_actors;

SELECT COUNT(*)
FROM film_actor;

SELECT COUNT(*)
FROM tmp_film_actors;

SELECT COUNT(*)
FROM film;

-- highest-grossing film
DROP TABLE IF EXISTS tmp_film_rentals;
CREATE TEMPORARY TABLE tmp_film_rentals AS
SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count
FROM film AS f
         LEFT JOIN inventory AS i USING (film_id)
         LEFT JOIN rental AS r USING (inventory_id)
GROUP BY f.film_id, f.title;

SELECT *
FROM tmp_film_rentals;

SELECT COUNT(*)
FROM tmp_film_rentals;

SELECT COUNT(*)
FROM film;

SELECT SUM(rental_count)
FROM tmp_film_rentals;
SELECT COUNT(*)
FROM rental;

SELECT *
FROM film;
DROP TABLE IF EXISTS tmp_film_payments;
CREATE TEMPORARY TABLE tmp_film_payments AS
SELECT f.film_id,
       f.title,
       SUM(p.amount) AS suma_wpłat
FROM film f
         LEFT JOIN inventory i USING (film_id)
         LEFT JOIN rental r USING (inventory_id)
         LEFT JOIN payment p USING (rental_id)
GROUP BY f.film_id;

SELECT *
FROM tmp_film_payments;


SELECT SUM(suma_wpłat)
FROM tmp_film_payments;


SELECT SUM(amount)
FROM payment;

SELECT COUNT(*)
FROM tmp_film_payments;

SELECT COUNT(*)
FROM film;

SELECT *
FROM payment p
WHERE NOT EXISTS (SELECT *
                  FROM rental r
                  WHERE r.rental_id = p.rental_id);


SELECT p.film_id,
       r.title,
       a.count_actors,
       r.rental_count,
       p.suma_wpłat
FROM tmp_film_actors a
         JOIN tmp_film_rentals r USING (film_id)
         JOIN tmp_film_payments p USING (film_id)
ORDER BY p.suma_wpłat DESC
LIMIT 10;

SELECT p.film_id,
       r.title,
       a.count_actors,
       r.rental_count,
       p.suma_wpłat
FROM tmp_film_actors a
         JOIN tmp_film_rentals r USING (film_id)
         JOIN tmp_film_payments p USING (film_id)
ORDER BY r.rental_count DESC
LIMIT 10;

SELECT s.store_id,
       s.staff_id,
       SUM(p.amount)
FROM staff s
         JOIN payment p USING (staff_id)
GROUP BY s.store_id, s.staff_id
WITH ROLLUP;

-- ROLLUP I HAVING

SELECT p.customer_id,
       p.staff_id,
       SUM(p.amount) AS payments
FROM staff s
         JOIN payment p USING (staff_id)
WHERE p.customer_id < 4
GROUP BY p.customer_id, p.staff_id
WITH ROLLUP
HAVING payments > 70;

-- 06:03:53

