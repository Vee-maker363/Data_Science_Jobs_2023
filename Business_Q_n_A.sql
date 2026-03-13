--Question 1: What are the top-paying jobs by roles?
/*
-   List the top-10 heighest paying jobs for the role (Data Analyst) that are remote.
    The output should include the Jop_id, job title, company name, salary, job_location, schedule type and job posted date.

-   Only output jobs with non-null salary values.
*/

SELECT 
    job_id,
    cd.name as company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact as jpf
LEFT JOIN company_dim as cd 
ON jpf.company_id = cd.company_id
WHERE job_location = 'Anywhere' 
AND job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

--Question 2: What are the skills required for the top-paying jobs?

--Question 3: What are the most in-demand skills for the top-paying jobs?

--Question 4: What are the skills based on salary for the roles?

--Question 5: What are the most optimal () skills to learn? 