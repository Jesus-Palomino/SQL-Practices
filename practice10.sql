-- Extensions
-- Allow to add functions to a data base


-- Cross tabulations

CREATE EXTENSION tablefunc;

-- Creating ice_cream_survey table and importing values

CREATE TABLE ice_cream_survey (
    response_id integer PRIMARY KEY,
    office text,
    flavor text
);

COPY ice_cream_survey
FROM '/tmp/ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER);


-- Crosstab

SELECT *
FROM crosstab('SELECT office,
                      flavor,
                      count(*)
               FROM ice_cream_survey
               GROUP BY office, flavor
               ORDER BY office',

              'SELECT flavor
               FROM ice_cream_survey
               GROUP BY flavor
               ORDER BY flavor')

AS (office text,
    chocolate bigint,
    strawberry bigint,
    vanilla bigint);


-- CHALLENGE: USE OFFICE AS PIVOT INSTEAD OF FLAVOR

SELECT *
FROM crosstab('SELECT flavor,
                      office,
                      count(*)
               FROM ice_cream_survey
               GROUP BY flavor, office
               ORDER BY flavor',

              'SELECT office
               FROM ice_cream_survey
               GROUP BY office
               ORDER BY office')

AS (flavor text,
    "Downtown" bigint,
    "Midtown" bigint,
    "Uptown" bigint);