CREATE DATABASE MENTAL_HEALTH;

USE MENTAL_HEALTH;

SELECT * FROM 
Student_Mental_Stress_and_Coping_Mechanisms;

--TO GIVE SHORTER NAME TO TABLE ;
CREATE VIEW SMS_CM AS
SELECT * FROM Student_Mental_Stress_and_Coping_Mechanisms;

--TO GET ALL COLUMNS :


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SMS_CM'


SELECT * FROM SMS_CM;

--FIND THE TOTAL NUMBER OF STUDENTS IN THE DATASET :

SELECT 
     COUNT(STUDENT_ID)
	 AS 'TOTAL STUDENTS'
FROM
     SMS_CM 
;


--RETIREVE THE AVERAGE GPA OF STUDENTS 

SELECT 
   AVG(ACADEMIC_PERFORMANCE_GPA)
   AS 'AVERAGE GPA'
FROM 
  SMS_CM
;

--LIST ALL THE STUDENT WHOSE GPA IS ABOVE 3.5 :

SELECT  
      *
FROM 
    SMS_CM
WHERE
    Academic_Performance_GPA > 3.5 
;



--FIND THE NUMBER OF STUDENTS WITH MEDICAL CONDITION :

SELECT 
      STUDENT_ID
	  ,GENDER
	  ,AGE
	  ,Academic_Performance_GPA
      ,COUNT(*) AS 
	 'STUDENTS WITH MEDICAL CONDITION'
FROM
     SMS_CM
WHERE
     Medical_Condition = 1
GROUP BY
      STUDENT_ID
	  ,GENDER
	  ,AGE
	  ,Academic_Performance_GPA
ORDER BY 
       AGE
;


--LIST ALL THE MALE STUDENT WHO SPEND MORE THAN 3 HOURS ON SOCIAL MEDIA PER DAY:

SELECT 
      Student_ID
	  ,Age
	  ,Gender
	  ,Academic_Performance_GPA
	  ,Social_Media_Usage_Hours_per_day
FROM
    SMS_CM
WHERE
    Gender = 'MALE'  
	AND
    Social_Media_Usage_Hours_per_day > 3
GROUP BY
     Student_ID
	 ,Age
	 ,Gender
	 ,Academic_Performance_GPA
	 ,Social_Media_Usage_Hours_per_day
ORDER BY 
     Social_Media_Usage_Hours_per_day
;


--GROUP STUDENT BY THEIR SLEEP DURATION AND FIND THE AVERAGE GPA IN EACH GROUP :

SELECT 
      Sleep_Duration_Hours_per_night
	 ,AVG(ACADEMIC_PERFORMANCE_GPA)
	  AS 'AVERAGE GPA'
FROM
    SMS_CM
GROUP BY
     Sleep_Duration_Hours_per_night	
ORDER BY 
     Sleep_Duration_Hours_per_night
;

SELECT * FROM
    SMS_CM

/* FIND THE MAXIMUM AND MINIMUM STRESS LEVELS AMONG STUDENTS WHO EXERCISE MORE THAN 5 HOURS 
PER WEEK */

SELECT 
     GENDER
	 ,Academic_Performance_GPA
	 ,Physical_Exercise_Hours_per_week
	 ,MAX(MENTAL_STRESS_LEVEL)
	 AS 'MAXIMUM STRESS LEVEL'
	 ,MIN(MENTAL_STRESS_LEVEL)
	 AS 'MINIMUM STRESS LEVEL'
FROM
     SMS_CM
WHERE 
     Physical_Exercise_Hours_per_week > 5
GROUP BY
     GENDER
	 ,Academic_Performance_GPA
	 ,Physical_Exercise_Hours_per_week
ORDER BY 
     Gender
;

/* CALCULATE THE TOTAL HOURS SPENT ON PHYSICAL EXERCISE BY STUDENTS WITH LOW 
FAMILY SUPPORT */

SELECT 
     SUM(PHYSICAL_EXERCISE_HOURS_PER_WEEK)
	 AS 'TOTAL HOUR SPENT ON PHYSICAL EXERCISE'
FROM
    SMS_CM
WHERE
    Family_Support = 1
;


--SHOW THE TOTAL NUMBER OF STUDENTS GROUPED BY THEIR DIET QUALITY :

SELECT 
      DIET_QUALITY
      ,COUNT(STUDENT_ID)
	  AS 'TOTAL STUDENT'
FROM
    SMS_CM
GROUP BY
     Diet_Quality
ORDER BY
    Diet_Quality
;



--FIND THE STUDENTS WHO HAVE THE HIGHEST GPA IN THEIR RESPECTIVE AGE GROUPS :

SELECT
     Student_ID
	 ,Gender
     ,AGE
	 ,ACADEMIC_PERFORMANCE_GPA
     ,MAX(ACADEMIC_PERFORMANCE_GPA)
	 AS 'HIGHEST GPA'
FROM
    SMS_CM
GROUP BY
    Age
   ,Student_ID
   ,Gender
   ,ACADEMIC_PERFORMANCE_GPA
ORDER BY 
    Age
;



--LIST THE STUDENTS WHO HAVE A GPA HIGHER THAN THE AVERAGE GPA OF ALL STUDENTS :

SELECT 
    *
FROM
   SMS_CM
WHERE
   Academic_Performance_GPA >
            (
			 SELECT 
				  AVG(Academic_Performance_GPA)
		     FROM
				 SMS_CM
	)
	 ;



--FIND THE PAIRS OF STUDENTS FROM THE SAME AGE GROUPS AND SHOW THIER RESPECTIVE GPAs.

SELECT 
     S.STUDENT_ID AS STUDENT_1
	 ,E.STUDENT_ID AS STUDENT_2
	 ,S.AGE
	 ,S.ACADEMIC_PERFORMANCE_GPA
	 ,E.ACADEMIC_PERFORMANCE_GPA
FROM 
    SMS_CM AS S
JOIN
    SMS_CM AS E
ON
   S.AGE = E.AGE
AND
   S.Student_ID = E.Student_ID
;

--FIND THE STUDENT WHO EXPERIENCE HIGH FINANCIAL,RELATIONASHIP AND MENTAL STRESS:

SELECT 
    Student_ID
    ,AGE 
    ,Gender
	,Financial_Stress
	,Relationship_Stress
	,Mental_Stress_Level
FROM 
    SMS_CM
WHERE 
    Financial_Stress = (
	                    SELECT 
						    MAX(Financial_Stress) 
						FROM 
						    SMS_CM
					    )
    AND Relationship_Stress = (
	                     SELECT 
						     MAX(Relationship_Stress)
						 FROM 
						     SMS_CM
						)
    AND Mental_Stress_Level = (
	                     SELECT 
						      MAX(Mental_Stress_Level) 
						 FROM SMS_CM
						 )
				;


--RANK STUDENTS BASED ON THEIR GPA :

SELECT 
      STUDENT_ID
	  ,Age
	  ,Gender
	  ,Academic_Performance_GPA
	  ,RANK() OVER(ORDER BY 
	  Academic_Performance_GPA
	  DESC ) AS 'GPA_RANK'
FROM
     SMS_CM
;



--CALCULATE THE AVERAGE GPA OF STUDENTS IN EACH AGE GROUP :

SELECT 
     Student_ID
	 ,AGE
	 ,Gender
	 ,AVG(Academic_Performance_GPA)
	 OVER (PARTITION BY AGE)
	 AS 'AGE_GROUP_AVERAGE_GPA'
FROM
    SMS_CM
;

--FIND THE CUMULATIVE TOTAL OF STUDY HOURS PER WEEK FOR ALL STUDENTS :

SELECT
      Student_ID
	  ,Age
	  ,Gender
	  ,Academic_Performance_GPA
	  ,Study_Hours_Per_Week
	  ,SUM(Study_Hours_Per_Week)
	  OVER(ORDER BY Student_ID)
	  AS 'CUMULATIVE STUDY HOURS'
FROM
    SMS_CM
	;


--USE A CTE TO FIND THE TOP 5 STUDENTS WITH THE HIGHEST GPA:

WITH TOP_5_STUDENT AS (
                        SELECT
						     TOP 5
							 Student_ID
							 ,AGE
							 ,Gender
							 ,Academic_Performance_GPA
						FROM
						     SMS_CM
						GROUP BY
						     Student_ID
							 ,AGE
							 ,Gender
							 ,Academic_Performance_GPA
						ORDER BY
						     Academic_Performance_GPA
							 DESC
					)
				
SELECT 
      *
FROM
    TOP_5_STUDENT 
	;


--CRAETE A CTE WHO HAS HIGH MENTAL STRESS LEVEL AND ALSO ATTEND COUNSELLING :

WITH MENTAL_STRESS_AND_COUNSELLING 
            AS (
                SELECT 
				   Student_ID
				   ,Mental_Stress_Level
				   ,Counseling_Attendance
                FROM 
                    SMS_CM
				WHERE
				    Counseling_Attendance = 1
					AND
					Mental_Stress_Level > 7
			)

SELECT * FROM
MENTAL_STRESS_AND_COUNSELLING
	;


--CREATE A VIEW TO SHOW STUDENTS WITH A GPA GREATER THAN 3.0 AND PHYSICAL EXERCISE ABOVE 3 HOURS PERWEEK.

CREATE VIEW 
ACTIVE_AND_SUCCESSFUL_STUDENTS
AS
  SELECT
       *
  FROM
      SMS_CM
  WHERE
      Academic_Performance_GPA > 3
	  AND
	  Physical_Exercise_Hours_per_week > 3
;

SELECT  *  FROM 
ACTIVE_AND_SUCCESSFUL_STUDENTS
WHERE Sleep_Duration_Hours_per_night = 12;


--CREATE A VIEW FOR STUDENTS WHO HAVE HIGH FINANCIAL STRESS BUT ALSO HAVE STRONG FAMILY SUPPORT :

CREATE VIEW 
HIGH_FINANCIAL_AND_FAMILY_SUPPORTS
AS
   SELECT
       Student_ID
	   ,Age
	   ,Gender
	   ,Financial_Stress
	   ,Family_Support
   FROM
       SMS_CM
   WHERE
       Financial_Stress > 3
	   AND
	   Family_Support >2
;
	  
SELECT * FROM
HIGH_FINANCIAL_AND_FAMILY_SUPPORTS
WHERE AGE > 20 ;


DROP VIEW HIGH_FINANCIAL_AND_FAMILY_SUPPORT ;


--FIND THE CERTAIN CORRELATION BETWEEN STUDY HOURS PER WEEK AND GPA USING SQL FUNCTIONS :

--THERE IS NO FUNCTION OR WAY TO FIND CORREALTION IN MS SQL 
--WE CAN DO IT USING PEARSON CORRELATION COEFFICIENT FORMULA

--IN OTHER :
/* SELECT 
     CORR(STUDY_HOURS_PER_WEEK,
	 Academic_Performance_GPA)
	 AS CORRELATION
FROM
    SMS_CM */


/* ANALYZE THE IMPACT OF PHYSICAL EXERCISE AND FAMILY SUPPORT ON STRESS LEVELS USING A COMBINATION
OF WINDOW FUNCTION AND CTE */


WITH STRESS_FACTOR
AS (
    SELECT
	     Student_ID
		 ,Gender
		 ,Age
		 ,Physical_Exercise_Hours_per_week
		 ,Family_Support
		 ,Mental_Stress_Level
	FROM
	    SMS_CM
)

SELECT
	     Student_ID
		 ,Gender
		 ,Age
		 ,Physical_Exercise_Hours_per_week
		 ,Family_Support
		 ,AVG(Mental_Stress_Level)
		 OVER(PARTITION BY 
		 Physical_Exercise_Hours_per_week
		 ) AS AVG_STRESS
FROM
	STRESS_FACTOR
	;


SELECT * FROM 
SMS_CM

/* CREATE A QUERY THAT CATEGORIES STUDENTS INTO DIFFERENT SLEEP GROUPS BASED ON THIER 
SLEEP_DURATION_HOURS_PER_NIGHT AS FOLLOWS :
LESS THAN 6 HOURS - 'INSUFFICIENT SLEEP'
BETWEEN 6 TO 8 HOURS - 'ADEQUATE SLEEP'
MORE THAN 8 HOURS - 'EXCESSIVE SLEEP' */


SELECT
     STUDENT_ID
	 ,AGE
	 ,GENDER
	 ,SLEEP_DURATION_HOURS_PER_NIGHT
   ,CASE
      WHEN
	  SLEEP_DURATION_HOURS_PER_NIGHT < 6 THEN 'INSUFFICIENT SLEEP'
	  WHEN
	  SLEEP_DURATION_HOURS_PER_NIGHT BETWEEN 6 AND 8 THEN 'ADEQUATE SLEEP'
	  ELSE
	  'EXCESSIVE SLEEP'
   END AS 
       SLEEP_CATEGORY
FROM
    SMS_CM
	;


/* Create a query that flags students with a high level of Mental_Stress_Level.
A student is considered to have "High Stress" 
if their Mental_Stress_Level is above 7 
and "Normal Stress" otherwise. */

SELECT 
    Student_ID
	,Age
	,Academic_Performance_GPA
	,Mental_Stress_Level
	,CASE
	     WHEN Mental_Stress_Level > 7 
		 THEN 'High Stress'
		 ELSE
		     'Normal Stress'
	END AS
	  STRESS_FLAG
FROM
  SMS_CM
  ;
