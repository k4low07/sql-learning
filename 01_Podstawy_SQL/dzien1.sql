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





