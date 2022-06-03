/*
Constraints

Primary keys must be: 
Unique -  It cant be repeated
Not null - It must have a value (specified by NOT NULL)

Foreign Keys:
Have to exist in the referenced table

Constraints are used to validate data
*/

--CHECK examples:
--Validate that data exists: 
CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff'))
--Validate value:
CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)


