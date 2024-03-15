create database Hr;
use Hr;

select * from Hr_Details;

EXEC sp_help 'Hr_Details';

EXEC.sp_rename 'Hr_Details.id' ,'emp_id';

Alter Table Hr_Details Add Age Int;

UPDATE Hr_Details
SET age = datediff(YEAR, birthdate ,GETDATE());

select  Age,birthdate from Hr_Details;

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM Hr_Details;

SELECT count(*) FROM Hr_Details WHERE age > 18;
