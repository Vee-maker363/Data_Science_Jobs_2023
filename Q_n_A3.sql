--Question 3: What are the most in-demand skills for the top-paying jobs?

/*
Write a query to list the top 5 most in-demand skills for the Data Analyst that are remote.
And compare the result for the same role regardless of location.
*/

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

--OR 

SELECT
    sd.skills,
    count(*) as skill_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst' 
AND jpf.job_work_from_home IS TRUE --or job_location = 'Anywhere'
GROUP BY sd.skills
ORDER BY skill_count DESC
LIMIT 5;

--For all job postings regardless of location

SELECT
    sd.skills,
    count(*) as skill_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst' 
GROUP BY sd.skills
ORDER BY skill_count DESC
LIMIT 5;
