-- INDEXES
-- Data structure technique used to improve performance when retreiving data.
-- Allow database optimizing by making it possible to quickly locate and access data in the database.
-- Utilizes data structures such as trees and hashes.

-- Create table
CREATE TABLE new_york_addresses (
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number text,
    street text,
    unit text,
    postcode text,
    id integer CONSTRAINT new_york_key PRIMARY KEY
);

-- import data
COPY new_york_addresses
FROM 'C:\YourDirectory\city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 8-13: Benchmark queries for index performance

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';

-- Listing 8-14: Creating a B-tree index on the new_york_addresses table

CREATE INDEX street_idx ON new_york_addresses (street);

-- After creating the index the execution time of the same query is reduced.
-- This is allowed because the data is saved as pointers.