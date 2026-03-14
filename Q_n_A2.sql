--Question 2: What are the skills required for the top-paying jobs?
/*
-  Using the query from question 1, list the speifi skills required for the role. 
*/

WITH top_10 AS (
SELECT 
    jpf.job_id,
    job_title,
    salary_year_avg,
    cd.name as company_name
FROM job_postings_fact as jpf
LEFT JOIN company_dim as cd 
    ON jpf.company_id = cd.company_id
WHERE job_location = 'Anywhere' 
AND job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
)

SELECT
    t.*,
    sd.skills
FROM 
top_10 as t
INNER JOIN skills_job_dim AS sjd
ON t.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sd.skill_id = sjd.skill_id
ORDER BY salary_year_avg DESC; 

/*



*/
