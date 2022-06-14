-- Views and materialized

-- Views: The query is stored
-- Materialized views: The results form the query are stored


-- Creating a view

CREATE OR REPLACE VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada';

SELECT *
FROM nevada_counties_pop_2019
ORDER BY county_fips
LIMIT 5;

UPDATE nevada_counties_pop_2019
SET county_name = 'YES_Nevada'
WHERE county_name = 'Nevada';

DROP VIEW nevada_counties_pop_2019;


-- Creating a materialized view

CREATE MATERIALIZED VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada';


REFRESH MATERIALIZED VIEW nevada_counties_pop_2019;

CREATE UNIQUE INDEX nevada_counties_pop_2019_fips_idx ON nevada_counties_pop_2019 (state_fips, county_fips);
REFRESH MATERIALIZED VIEW CONCURRENTLY nevada_counties_pop_2019;

DROP MATERIALIZED VIEW nevada_counties_pop_2019;



-- Functions and procedures
-- Function: Returns a value



-- Creating a function

CREATE OR REPLACE FUNCTION
percent_change(new_value numeric,
               old_value numeric,
               decimal_places integer DEFAULT 1)
RETURNS numeric AS
'SELECT round(
       ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- Testing the percent_change() function

SELECT percent_change(110, 108, 2);

-- Adding a column to the teachers table and seeing the data

ALTER TABLE teachers ADD COLUMN personal_days integer;

SELECT first_name,
       last_name,
       hire_date,
       personal_days
FROM teachers;


-- Creating a procedure

CREATE OR REPLACE PROCEDURE update_personal_days()
AS $$
BEGIN
    UPDATE teachers
    SET personal_days =
        CASE WHEN (now() - hire_date) >= '10 years'::interval
                  AND (now() - hire_date) < '15 years'::interval THEN 4
             WHEN (now() - hire_date) >= '15 years'::interval
                  AND (now() - hire_date) < '20 years'::interval THEN 5
             WHEN (now() - hire_date) >= '20 years'::interval
                  AND (now() - hire_date) < '25 years'::interval THEN 6
             WHEN (now() - hire_date) >= '25 years'::interval THEN 7
             ELSE 3
        END;
    RAISE NOTICE 'personal_days updated!';
END;
$$
LANGUAGE plpgsql;

-- Calling the procedure
CALL update_personal_days();


-- Triggers

--Creating tables and adding values
CREATE TABLE grades (
    student_id bigint,
    course_id bigint,
    course text NOT NULL,
    grade text NOT NULL,
PRIMARY KEY (student_id, course_id)
);

INSERT INTO grades
VALUES
    (1, 1, 'Biology 2', 'F'),
    (1, 2, 'English 11B', 'D'),
    (1, 3, 'World History 11B', 'C'),
    (1, 4, 'Trig 2', 'B');

CREATE TABLE grades_history (
    student_id bigint NOT NULL,
    course_id bigint NOT NULL,
    change_time timestamp with time zone NOT NULL,
    course text NOT NULL,
    old_grade text NOT NULL,
    new_grade text NOT NULL,
PRIMARY KEY (student_id, course_id, change_time)
);  

-- Create record_if_grade_changed() function

CREATE OR REPLACE FUNCTION record_if_grade_changed()
    RETURNS trigger AS
$$
BEGIN
    IF NEW.grade <> OLD.grade THEN
    INSERT INTO grades_history (
        student_id,
        course_id,
        change_time,
        course,
        old_grade,
        new_grade)
    VALUES
        (OLD.student_id,
         OLD.course_id,
         now(),
         OLD.course,
         OLD.grade,
         NEW.grade);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Creating a trigger

CREATE TRIGGER grades_update
  AFTER UPDATE
  ON grades
  FOR EACH ROW
  EXECUTE PROCEDURE record_if_grade_changed();


-- Testing the grades_update trigger

-- There should be no records
SELECT * FROM grades_history;

-- Checking the grades
SELECT * FROM grades ORDER BY student_id, course_id;

-- Updating a grade
UPDATE grades
SET grade = 'C'
WHERE student_id = 1 AND course_id = 1;

-- Checking the grades history again
SELECT student_id,
       change_time,
       course,
       old_grade,
       new_grade
FROM grades_history;