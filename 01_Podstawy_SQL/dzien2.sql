-- JOIN

SELECT r.rental_id,
       p.payment_id,
       p.amount,
       r.rental_date,
       p.payment_date
FROM rental AS r
         JOIN payment p
              ON r.rental_id = p.rental_id;


SELECT r.inventory_id,
       r.rental_id,
       i.film_id
FROM rental AS r
         JOIN inventory AS i ON r.inventory_id = i.inventory_id;


SELECT i.inventory_id,
       i.film_id,
       r.rental_id
FROM inventory i
         INNER JOIN rental r USING (inventory_id);


SELECT inventory_id,
       film_id,
       title,
       description,
       release_year
FROM film f
         JOIN inventory i USING (film_id);

SELECT rental_id,
       film_id,
       title,
       description,
       rating,
       rental_rate,
       rental_date,
       payment_date,
       amount
FROM film AS f
         JOIN inventory i USING (film_id)
         JOIN rental AS r USING (inventory_id)
         JOIN payment AS p USING (rental_id);

-- create database

CREATE DATABASE tasks;

CREATE TABLE city_country
(
    city       VARCHAR(50)       NOT NULL,
    country_id SMALLINT UNSIGNED NOT NULL,
    country    VARCHAR(50)
);

INSERT INTO city_country (city, country_id)
SELECT ci.city,
       ci.country_id
FROM sakila.city AS ci;


SELECT *
FROM tasks.city_country;

UPDATE tasks.city_country AS cc JOIN sakila.country AS c
    ON cc.country_id = c.country_id
SET cc.country = c.country
WHERE cc.country IS NULL;

SELECT cc.country as nowa_tabela, c.country as stara_tabela
from tasks.city_country cc join sakila.country c
using (country_id)
where country_id =82;

