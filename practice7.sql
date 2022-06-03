-- Database data clean up
-- Used to reduce errors caused by missing values or incorrect data.


CREATE TABLE meat_poultry_egg_establishments (
    establishment_number text CONSTRAINT est_number_key PRIMARY KEY,
    company text,
    street text,
    city text,
    st text,
    zip text,
    phone text,
    grant_date date,
    activities text,
    dbas text
);

COPY meat_poultry_egg_establishments
FROM '/workspace/SQL-Practice/git_environment/practical-sql-2/Chapter_10/MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX company_idx ON meat_poultry_egg_establishments (company);

Select count(*) from meat_poultry_egg_establishments;

-- Finding Duplicates
-- Identify the colums that will be unique
-- Group by creates a generalized group defined by the columns given
SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
FROM meat_poultry_egg_establishments
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

-- Group by and count to counting states.
SELECT st, 
       count(*) AS st_count
FROM meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;


-- Finding missing data
-- Check if data is NULL.
SELECT establishment_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_establishments
WHERE st IS NULL;


-- Length() can be utilized to solve errors in data that involve its lenght.
SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip) ASC;

-- Filter data to find zip values with a lower length than 5
SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_establishments
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;


-- Fixing missing data 
-- 1. Always Create a back-up table
CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT * FROM meat_poultry_egg_establishments;

-- 2. If possible, create a new column to fix the missing data
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy text;
UPDATE meat_poultry_egg_establishments

SELECT st,
       st_copy
FROM meat_poultry_egg_establishments
WHERE st IS DISTINCT FROM st_copy
ORDER BY st;
SET st_copy = st;

-- 3. Updating the ST column for the 'WI' value.
UPDATE meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;


-- 4. Fix data
-- Modify zip values that are missing two leading zeros
UPDATE meat_poultry_egg_establishments
SET zip = '00' || zip -- Concatenate 00 + ZipCode
WHERE st IN('PR','VI') AND length(zip) = 3;

-- Modify zip values that are missing one leading zero
UPDATE meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;


-- Removing duplicate data
DELETE FROM meat_poultry_egg_establishments
WHERE establishment_number NOT IN (
	SELECT max(establishment_number)
	FROM meat_poultry_egg_establishments
	GROUP BY company, street, city, st
);


-- Changing with backup data

-- If column was made a backup
UPDATE meat_poultry_egg_establishments
SET st = st_copy;

--If a table was made a backup
UPDATE meat_poultry_egg_establishments original
SET st = backup.st
FROM meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number


-- Challenge
--Add a new colum meat_processing (boolean) set this column to true if the company has 'Meat Processing'

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN meat_processing bool;

UPDATE meat_poultry_egg_establishments
set meat_processing = TRUE
WHERE activities like '%Meat Processing%';

UPDATE meat_poultry_egg_establishments
set meat_processing = FALSE
WHERE activities not like '%Meat Processing%';

SELECT activities, meat_processing FROM meat_poultry_egg_establishments where meat_processing = TRUE;

-- Transactions
-- Help to group db operations, rollbacks, commits

--Rollback changes
START TRANSACTION 
update meat_poultry_egg_establishments
SET company = 'Gdl'

SELECT company,* FROM meat_poultry_egg_establishments

ROLLBACK;
--Commit changes
COMMIT;