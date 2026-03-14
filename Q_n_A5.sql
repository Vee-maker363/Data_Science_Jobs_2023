--Question 5: What are the most optimal skills to learn for Data Analyst roles? 
/*
- Based on the previous questions (Q_n_A3), 
list the skills that are most in-demand and have the highest average salary for the role (Data Analyst) that are remote.

*/

WITH most_demand_skills AS (
    SELECT
        sd.skill_id,
        sd.skills,
        count(*) as skill_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Analyst' 
    AND jpf.job_work_from_home IS TRUE --or job_location = 'Anywhere'
    AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id
  
), skill_based_salary AS (
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 2) as avg_salary
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Analyst' 
    AND jpf.job_work_from_home IS TRUE --or job_location = 'Anywhere'
    AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id
)

SELECT
    most_demand_skills.skill_id,
    most_demand_skills.skills,
    skill_count,
    avg_salary
FROM most_demand_skills
INNER JOIN skill_based_salary
ON most_demand_skills.skill_id = skill_based_salary.skill_id
ORDER BY skill_count DESC, avg_salary DESC 
LIMIT 10;

/*
- Demand Based Result
| Skill      | Frequency |
| ---------- | --------- |
| SQL        | 7291      |
| Excel      | 4611      |
| Python     | 4330      |
| Tableau    | 3745      |
| R          | 2993      |
| Power BI   | 2609      |
| SAS        | 2124      |
| Sheets     | 1904      |
| PowerPoint | 1865      |
| Word       | 1851      |

- Salary Based Result
| Skill          | Average Salary |
| -------------- | -------------- |
| PySpark        | 208172.25      |
| Bitbucket      | 189154.50      |
| Watson         | 160515.00      |
| Couchbase      | 160515.00      |
| DataRobot      | 155485.50      |
| GitLab         | 154500.00      |
| Swift          | 153750.00      |
| Jupyter        | 152776.50      |
| Pandas         | 151821.33      |
| Elasticsearch  | 145000.00      |