-- Missing text

-- Formatting text
SELECT upper('Neal7');
SELECT lower('Randy');
SELECT initcap('at the end of the day');
SELECT initcap('Practical SQL');

-- Text attributes
SELECT char_length(' Pat ');
SELECT length(' Pat ');
SELECT position(', ' in 'Tan, Bella');

-- Deleting characters
SELECT trim('s' from 'socks');
SELECT trim(trailing 's' from 'socks');
SELECT trim(' Pat ');
SELECT char_length(trim(' Pat '));
SELECT ltrim('socks', 's');
SELECT rtrim('socks', 's');

-- Selecting and replacing characters
SELECT left('703-555-1212', 3);
SELECT right('703-555-1212', 8);
SELECT replace('bat', 'b', 'c');


-- Regular Expressions

-- Any character one or many times
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '.+');

-- One or two digits followed by a space and a.m. or p.m. in a noncapture group
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\d{1,2} (?:a.m.|p.m.)');

-- One or more word characters at the start
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '^\w+');

-- One or more word characters followed by any character at the end.
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\w+.$');

-- The words May or June
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from 'May|June');

-- Four digits
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\d{4}');

-- May followed by a space, digit, comma, space, and four digits.
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from 'May \d, \d{4}');


-- Using regular expressions in a WHERE clause

SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* '(lade|lare)'
ORDER BY county_name;

SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* 'ash' AND county_name !~ 'Wash'
ORDER BY county_name;


--Using Regular expressions to replace and split text

SELECT regexp_replace('05/12/2024', '\d{4}', '2023');

SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');

SELECT regexp_split_to_array('Phil Mike Tony Steve', ' ');


-- CHALLENGE: Create a regular expression for ID
(C|SO)\d{9,10}