-- Math operations in sql 

-- 1) Basic operations
SELECT 2 + 2;    -- addition
SELECT 9 - 1;    -- subtraction
SELECT 3 * 4;    -- multiplication

-- 2) Integer and decimal division
SELECT 11 / 6;   -- integer division
SELECT 11 % 6;   -- module division
SELECT 11.0 / 6; -- decimal division
SELECT CAST(11 AS numeric(3,1)) / 6;

-- 3) Exponents, roots and factorials
SELECT 3 ^ 4;         -- exponentiation
SELECT |/ 10;         -- square root (operator)
SELECT sqrt(10);      -- square root (function)
SELECT ||/ 10;        -- cube root
SELECT factorial(4);  -- factorial (function)
SELECT 4 !;           -- factorial (operator; PostgreSQL 13 and earlier only)

-- 4) Percentile function
CREATE TABLE percentile_test (
    numbers integer
);

INSERT INTO percentile_test (numbers) VALUES
    (1), (2), (3), (4), (5), (6);
    
SELECT
    percentile_cont(.5)
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5)
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;

-- 5) Functions sum(), avg() and percentile_cont()
SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average,
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY pop_est_2019) AS county_median
FROM us_counties_pop_est_2019;
