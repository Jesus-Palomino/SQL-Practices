-- 1) Select teachers' school and firstname ordered by alphabetical order
select school, first_name FROM teachers ORDER BY school, first_name ASC;

-- 2) Select teachers that have a salary higher than 40000 and a name starting with S
select first_name FROM teachers WHERE first_name LIKE 'S%' AND salary > 40000;

-- 3) Select techers that were hired after 2010-01-01 ordered by salary high to low
select first_name FROM teachers WHERE hire_date > '2010-01-01' ORDER BY salary DESC;