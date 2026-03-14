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
# Key Insights from the Data

## Most In-Demand Skills (Across Top Roles)
| Skill    | Frequency |
| -------- | --------- |
| SQL      | 398       |
| Excel    | 256       |
| Python   | 236       |
| Tableau  | 230       |
| R        | 148       |
| SAS      | 126       |
| Power BI | 110       |

# Visualization Tools Are Critical
| Tool     | Frequency |
| -------- | --------- |
| Tableau  | 230       |
| Power BI | 110       |
| Looker   | 49        |

# Programming Skills Are Expected
| Tool   | Frequency |
| ------ | --------- |
| Python | 236       |
| R      | 148       |

# Database & Data Infrastructure Skills
| Tool       | Frequency |
| ---------- | --------- |
| Snowflake  | 37        |
| SQL Server | 35        |
| Oracle     | 37        |

# Cloud Skills Are Emerging
| Tool  | Frequency |
| ----- | --------- |
| Azure | 34        |
| AWS   | 32        |

# Business & Office Tools Still Matter
| Tool       | Frequency |
| ---------- | --------- |
| PowerPoint | 58        |
| Word       | 48        |
| Sheets     | 32        |

*/
