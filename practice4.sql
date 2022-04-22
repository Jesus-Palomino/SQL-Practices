-- 1. Create tables and insert values

CREATE TABLE district_2020 (
    id integer CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 text
);

CREATE TABLE district_2035 (
    id integer CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 text
);

INSERT INTO district_2020 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Dover Middle School'),
    (6, 'Webutuck High School');

INSERT INTO district_2035 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Webutuck High School');
    

CREATE TABLE departments (
    dept_id integer,
    dept text,
    city text,
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees (
    emp_id integer,
    first_name text,
    last_name text,
    salary numeric(10,2),
    dept_id integer REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

INSERT INTO departments
VALUES
    (1, 'Tax', 'Atlanta'),
    (2, 'IT', 'Boston');

INSERT INTO departments
VALUES
	(3, 'Dev', 'Guadalajara'),
	
INSERT INTO employees
VALUES
    (1, 'Julia', 'Reyes', 115300, 1),
    (2, 'Janet', 'King', 98000, 1),
    (3, 'Arthur', 'Pappas', 72700, 2),
    (4, 'Michael', 'Taylor', 89500, 2);
	
INSERT INTO employees
VALUES
    (5, 'Miguel', 'Palomenra', 89500, null);
    


-- 2. JOIN, INNER JOIN, LEFT JOIN, RIGHT JOIN

-- JOIN
SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id
ORDER BY employees.dept_id;

-- INNER JOIN
SELECT *
FROM district_2020 INNER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- LEFT JOIN
SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- RIGHT JOIN
SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2035.id;

-- FULL OUTER JOIN
SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- CROSS JOIN
SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id, district_2035.id;
-- CROSS JOIN can be represented by a comma EX. FROM district_2020, JOIN district_2035



-- 3. UNION

-- Combining query results with UNION
SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;

-- Combining query results with UNION ALL
SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;

-- Customizing UNION query
SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020

UNION ALL

SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;


-- 4. INTERSECT - Select all that are in both
SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

-- 5. EXCEPT - Select all district_2020 that are not in district_2035
SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;