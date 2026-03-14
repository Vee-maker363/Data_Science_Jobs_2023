--Question 4: What are the skills based on salary for the roles?

/*
- What is the average salary for each skill for the role (Data Analyst) that are remote?
- And compare the result for the same role regardless of location.
*/

SELECT
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
GROUP BY sd.skills
ORDER BY avg_salary DESC
LIMIT 20;

/*
# Python Data Science Ecosystem

Several of the highest-paying skills belong to the Python analytics ecosystem.
| Tool         | Avg Salary |
| ------------ | ---------- |
| Pandas       | $151,821   |
| NumPy        | $143,512   |
| Scikit-learn | $125,781   |
| Jupyter      | $152,776   |
| PySpark      | $208,172   |

# Big Data & Modern Data Platforms
| Tool          | Avg Salary |
| ------------- | ---------- |
| Databricks    | $141,906   |
| PySpark       | $208,172   |
| Elasticsearch | $145,000   |
| Couchbase     | $160,515   |

# Machine Learning & AI Tools
| Tool         | Avg Salary |
| ------------ | ---------- |
| DataRobot    | $155,485   |
| Watson       | $160,515   |
| Scikit-learn | $125,781   |

# DevOps & Version Control Tools
| Tool      | Avg Salary |
| --------- | ---------- |
| Bitbucket | $189,154   |
| GitLab    | $154,500   |
| Jenkins   | $125,436   |
| Atlassian | $131,161   |

# Data Engineering & Workflow Automation
| Tool       | Avg Salary |
| ---------- | ---------- |
| Airflow    | $126,103   |
| Kubernetes | $132,500   |

# Infrastructure and System Skills
| Tool       | Avg Salary |
| ---------- | ---------- |
| Linux      | $136,507   |
| Kubernetes | $132,500   |

# Programming Languages Outside Traditional Analytics
| Language | Avg Salary |
| -------- | ---------- |
| Golang   | $145,000   |
| Swift    | $153,750   |



Insight

These tools form the core Python data analysis stack:

NumPy → numerical computing

Pandas → data manipulation

Scikit-learn → machine learning

Jupyter → analysis environment

PySpark → big data processing

Addtionally, The highest-paying remote Data Analyst roles tend to involve skills beyond traditional analytics tools. Instead, they emphasize capabilities in:

Python data science tools

Big data processing platforms

machine learning workflows

data engineering infrastructure

This suggests that analysts who expand their skill set toward data engineering and advanced analytics technologies are more likely to access the highest-paying opportunities.

*/