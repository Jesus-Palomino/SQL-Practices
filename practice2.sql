-- 1. Importing data to postgres
-- Copy csv file to tmp folder
-- Create table for the data in the csv file
-- Import data by using COPY
    COPY table_name
    FROM 'C:\YourDirectory\your_file.csv'
    WITH (FORMAT CSV, HEADER);
    
    -- Can import only rows with specific values by using WHERE
    -- Can import only a subset of rows
    -- Can import data to temporary table to add/delete/modify values as desired and then insert to table

-- 2. Exporting data from postgres
-- Export data by using COPY
    COPY us_counties_pop_est_2019
    TO 'C:\YourDirectory\us_counties_export.txt'
    WITH (FORMAT CSV, HEADER, DELIMITER '|');
    
    -- Can import selected columns
    -- Can import from a SELECT