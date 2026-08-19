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

SELECT cc.country AS nowa_tabela, c.country AS stara_tabela
FROM tasks.city_country cc
         JOIN sakila.country c
              USING (country_id)
WHERE country_id = 82;

-- CREATE TABLE FOR TRYING DELETE

DROP TABLE IF EXISTS tasks.films_to_be_cleaned;

CREATE TABLE tasks.films_to_be_cleaned
    LIKE sakila.film;

INSERT INTO tasks.films_to_be_cleaned
SELECT *
FROM sakila.film;

-- 1000 rows
SELECT COUNT(*)
FROM tasks.films_to_be_cleaned;

DELETE fc
FROM tasks.films_to_be_cleaned AS fc
         JOIN sakila.film_category AS fcat USING (film_id)
WHERE fcat.category_id IN (1, 5, 7, 9)
  AND fc.length < 60
  AND fc.rating NOT IN ('NC-17', 'PG');

-- tables without 16 rows after 'delete'
SELECT COUNT(*)
FROM tasks.films_to_be_cleaned;

SELECT *
FROM tasks.films_to_be_cleaned;


-- checking after delete
SELECT *
FROM tasks.films_to_be_cleaned AS fc
         JOIN sakila.film_category AS fcat USING (film_id)
WHERE fcat.category_id IN (1, 5, 7, 9)
  AND fc.length < 60
  AND fc.rating NOT IN ('NC-17', 'PG');

INSERT INTO tasks.films_to_be_cleaned
SELECT f.*
FROM sakila.film AS f
         JOIN sakila.film_category AS fc
              USING (film_id)
WHERE category_id IN (1, 5, 7, 9)
  AND length < 60
  AND rating NOT IN ('NC-17', 'PG');


-- create table

DROP TABLE IF EXISTS tasks.california_payments;

CREATE TABLE tasks.california_payments
    LIKE sakila.payment;

INSERT INTO tasks.california_payments
SELECT p.*
FROM sakila.payment AS p
         JOIN sakila.customer AS c
              ON p.customer_id = c.customer_id
         JOIN sakila.address AS a
              ON c.address_id = a.address_id
WHERE a.district = 'California';

SELECT *
FROM tasks.california_payments;

TRUNCATE TABLE tasks.california_payments;


SELECT address.district
FROM address
WHERE district = 'California';

INSERT INTO tasks.california_payments
SELECT p.*
FROM sakila.payment AS p
         JOIN sakila.customer AS c USING (customer_id)
         JOIN sakila.address AS a USING (address_id)
WHERE a.district = 'California';


SELECT cp.*
FROM tasks.california_payments cp
         JOIN sakila.customer AS c USING (customer_id)
         JOIN sakila.address AS a USING (address_id)
WHERE a.district = 'California';


-- CREATE TABLE FOR DELETE CASCADE
CREATE TABLE tasks.buildings
(
    building_no   INT PRIMARY KEY,
    building_name VARCHAR(255),
    address       VARCHAR(255)
);

CREATE TABLE tasks.rooms
(
    room_no     INT,
    room_name   VARCHAR(255) NOT NULL,
    building_no INT          NOT NULL,

    -- Tutaj znajduje się definicja klucza obcego
    FOREIGN KEY (building_no)

        -- do której kolumny oraz tabeli się odnosimy
        REFERENCES tasks.buildings (building_no)

        /*
        * poniższy fragment mówi, że gdy rekord zostanie
        * usunięty z buildings,
        * odnoszący się do niego wiersz z rooms - również
        */
        ON DELETE CASCADE
);


INSERT INTO tasks.buildings(building_no, building_name, address)
VALUES (1, 'ACME Headquarters', '3950 North 1st Street CA 95134'),
       (2, 'ACME Sales', '5000 North 1st Street CA 95134');

INSERT INTO tasks.rooms(room_no, room_name, building_no)
VALUES (1, 'Amazon', 1),
       (2, 'War Room', 1),
       (3, 'Office of CEO', 1),
       (4, 'Marketing', 2),
       (5, 'Showroom', 2);


SELECT *
FROM tasks.buildings;
SELECT *
FROM tasks.rooms;


-- delete
DELETE FROM tasks.buildings WHERE building_no = 1; -- usuwamy wiersze
SELECT * FROM tasks.buildings;
SELECT * FROM tasks.rooms;


USE information_schema;

SELECT
  UNIQUE_CONSTRAINT_SCHEMA,
  TABLE_NAME,
  REFERENCED_TABLE_NAME
FROM
  referential_constraints
WHERE delete_rule = 'CASCADE'
