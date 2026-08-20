SELECT COUNT(DISTINCT customer_id) as rows_amount
from payment;

SELECT customer_id
from payment;

SELECT actor_id, COUNT(film_id) as played_in
from film_actor
group by actor_id;