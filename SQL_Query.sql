-- DATE FUNCTIONS

SELECT 
    job_title_short AS Title,
    job_location AS Location,
    job_posted_date :: DATE AS Posted_Date
FROM 
    job_postings_fact;

SELECT 
    job_title_short AS Title,
    job_location AS Location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS Posted_Date
FROM 
    job_postings_fact
LIMIT 10;

SELECT 
    COUNT(job_id) AS Total_Jobs,
    EXTRACT(MONTH FROM job_posted_date) AS Months
FROM 
    job_postings_fact
GROUP BY
    Months
ORDER BY
    Total_Jobs DESC;


SELECT
    job_schedule_type as Schedule_Type, 
    AVG(salary_year_avg) as salary_year_avg,
    AVG(salary_hour_avg) as salary_hour_avg
FROM 
    job_postings_fact
WHERE
    job_posted_date >= '2023-06-01'
GROUP BY
    job_schedule_type;


SELECT
    EXTRACT(MONTH from job_posted_date at time zone 'AMERICA/NEW_YORK') as months,
    count(job_id) as job_count
FROM
    job_postings_fact
GROUP BY
    months
ORDER BY
    months DESC;

select * from company_dim limit 10;
select * from job_postings_fact limit 10;

SELECT
    cd.name AS Company_Name,
    jpf.job_title_short AS Job_Title,
    jpf.job_health_insurance AS Health_Insurance
FROM
    job_postings_fact as jpf
LEFT JOIN 
    company_dim as cd
ON 
    jpf.company_id = cd.company_id
WHERE  
    jpf.job_health_insurance  is TRUE 
    AND 
    EXTRACT(QUARTER FROM jpf.job_posted_date) = 2
LIMIT 10;

--Practice Problem 6
CREATE TABLE january_jobs AS
    SELECT 
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 3;

--CASE STATEMENT
SELECT
    job_title_short,
    job_location
FROM
    job_postings_fact;

SELECT
    COUNT(job_id) as Total_Jobs,
    CASE 
        WHEN job_location = 'New York, NY' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END AS Location_Categor
FROM    
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    Location_Categor;

SELECT
    COUNT(job_id) as Total_Jobs,
    CASE 
        WHEN salary_year_avg BETWEEN 25000 AND 50000 THEN 'Entry Level'
        WHEN salary_year_avg BETWEEN 50001 AND 100000 THEN 'Mid Level'
        WHEN salary_year_avg >= 100100 THEN 'Senior Level'
        ELSE 'Executive Level'
    END AS Salary_Level
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    Salary_Level
ORDER BY
    Total_Jobs DESC;

--Subqueries and CTEs

WITH jjobs AS (
    SELECT 
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
)

select 
    *
from 
    jjobs 
where job_title_short = 'Data Analyst'
limit 10;


SELECT
    company_id,
    name as company_name
FROM
    company_dim
WHERE
    company_id IN (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = TRUE);


WITH company_applicants AS (
    SELECT
        company_id,
        count(*) as count_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
    ORDER BY count_jobs DESC
)

/*select * from company_applicants
limit 10;*/

SELECT
    ca.company_id as company_id,
    cd.name as company_name,
    ca.count_jobs as total_jobs
FROM
    company_dim cd
LEFT JOIN
    company_applicants as ca
ON cd.company_id = ca.company_id
ORDER BY
    total_jobs DESC

--Practice Problem 7

select * from skills_dim limit 10;
select * from skills_job_dim limit 10;


SELECT
    sd.skill_id,
    sd.skills,
    sjd.skill_count
FROM
    skills_dim AS sd
JOIN (
    SELECT
        skill_id,
        count(*) as skill_count
    FROM
        skills_job_dim
    GROUP BY
        skill_id) AS sjd
ON sd.skill_id = sjd.skill_id
ORDER BY
    sjd.skill_count DESC
LIMIT 5;


SELECT
    cd.company_id,
    cd.name as company_name,
    jpf.total_jobs,
    CASE 
        WHEN jpf.total_jobs <= 10 THEN 'SMALL'
        WHEN jpf.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'LARGE'
    END AS size_category
FROM
    company_dim as cd
LEFT JOIN (
        SELECT
            company_id,
            count(*) as total_jobs
        FROM 
            job_postings_fact
        GROUP BY
            company_id) as jpf
ON cd.company_id = jpf.company_id
ORDER BY
    jpf.total_jobs DESC
LIMIT 15;

--Practice Problem 7

WITH remont_jobs AS (
        SELECT
            sjd.skill_id,
            count(*) as skill_count
        FROM
            skills_job_dim as sjd
        INNER JOIN
        job_postings_fact as jpf
        ON sjd.job_id = jpf.job_id
        WHERE jpf.job_work_from_home IS TRUE AND 
                jpf.job_title_short = 'Data Analyst'
        GROUP BY
            sjd.skill_id
            )

--select * from remont_jobs;

SELECT
    sd.skill_id,
    sd.skills,
    rj.skill_count
FROM
    remont_jobs as rj
LEFT JOIN
    skills_dim as sd
ON rj.skill_id = sd.skill_id
ORDER BY
    rj.skill_count DESC
LIMIT 5;

--UNION and UNION ALL


WITH jan AS (
        SELECT
            jb.job_id,
            sjd.skill_id
        FROM january_jobs jb
        LEFT JOIN skills_job_dim sjd
        ON jb.job_id = sjd.job_id
        WHERE jb.job_title_short = 'Data Analyst'
        ), feb AS (
        SELECT
            jb.job_id,
            sjd.skill_id
        FROM february_jobs jb
        LEFT JOIN skills_job_dim sjd
        ON jb.job_id = sjd.job_id
        WHERE jb.job_title_short = 'Data Analyst'
        ), mar AS (
        SELECT
            jb.job_id,
            sjd.skill_id
        FROM march_jobs jb
        LEFT JOIN skills_job_dim sjd
        ON jb.job_id = sjd.job_id
        WHERE jb.job_title_short = 'Data Analyst'
        )

SELECT
    sd.skills,
    sd.type
FROM 
    skills_dim as sd
JOIN jan
ON sd.skill_id = jan.skill_id
UNION
SELECT
    sd.skills,
    sd.type
FROM 
    skills_dim as sd
JOIN feb
ON sd.skill_id = feb.skill_id
UNION
SELECT
    sd.skills,
    sd.type
FROM 
    skills_dim as sd
JOIN mar
ON sd.skill_id = mar.skill_id

--OR 

SELECT
    sd.skills,
    sd.type
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND EXTRACT(QUARTER FROM jpf.job_posted_date) = 1
    AND jpf.salary_year_avg >= 70000;