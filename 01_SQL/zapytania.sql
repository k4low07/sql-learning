-- zadanie 1 Wyświetl tylko tytuły maksymalnie 10 filmów
SELECT title
FROM film
LIMIT 10;
-- zadanie 2 Wyświetl identyfikator i tytuł maksymalnie 15 filmów
SELECT film_id, title
FROM film
LIMIT 15;
-- zadanie 3 Wyświetl tytuł i opłatę za wypożyczenie maksymalnie 8 filmów
SELECT title, rental_rate
FROM film
LIMIT 8;
-- zadanie 4 Wyświetl tytuł, długość i opłatę za wypożyczenie maksymalnie 12 filmów
SELECT title, rental_rate, length
FROM film
LIMIT 12;
-- zadanie 5 Wyświetl wszystkie kolumny maksymalnie 4 filmów
SELECT *
FROM film
LIMIT 4;
-- zadanie 6 Wyświetl maksymalnie 6 filmów, ustawiając kolumny w kolejności: opłata za wypożyczenie → tytuł → identyfikator
SELECT rental_rate, title, film_id
FROM film
LIMIT 6;
-- zadaie 7 Wyświetl tytuł i długość filmów trwających ponad 120 minut.
SELECT title, length
FROM film
WHERE length > 120
ORDER BY length DESC;
-- zadanie 8 Wyświetl tytuł i długość filmów trwających mniej niż 90 minut.
SELECT title, length
FROM film
WHERE length < 90
ORDER BY length DESC;
-- zadanie 9 Wyświetl tytuł i opłatę za wypożyczenie filmów, których rental_rate wynosi dokładnie 2.99.
SELECT title, rental_rate
FROM film
WHERE rental_rate = 2.99
ORDER BY title;
-- zadanie 10 Wyświetl tytuł i opłatę za wypożyczenie maksymalnie 5 filmów, których rental_rate jest większe niż 2.99.
SELECT title, rental_rate
FROM film
WHERE rental_rate > 2.99
ORDER BY rental_rate DESC
LIMIT 5;
