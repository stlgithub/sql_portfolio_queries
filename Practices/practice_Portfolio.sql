--1. Top Paying Jobs--

SELECT
    company_dim.name,
    job_title_short,
    job_work_from_home,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = TRUE AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10


--2. Top Paying Job's Skills--

WITH top_paying_jobs AS(
SELECT
    job_id,
    company_dim.name,
    job_title_short,
    job_work_from_home,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = TRUE AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY top_paying_jobs.job_id


--3. In-Demand Skills--

SELECT 
    COUNT(skills_job_dim.job_id) as skill_count,
    skills_dim.skills
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY skill_count DESC
LIMIT 5


--4. Top Paying Skills--

SELECT 
    ROUND(AVG(salary_year_avg),2) as average_wage,
    skills_dim.skills
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY average_wage DESC
LIMIT 10


--5. Optimal Skills--

WITH in_demand_skills AS(
    SELECT 
        COUNT(skills_job_dim.job_id) as skill_count,
        skills_dim.skills
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_dim.skills
), highest_paying_skills AS(
    SELECT 
    ROUND(AVG(salary_year_avg),2) as average_wage,
    skills_dim.skills
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skills
)

SELECT
    in_demand_skills.skills,
    in_demand_skills.skill_count,
    highest_paying_skills.average_wage
FROM
    highest_paying_skills
INNER JOIN in_demand_skills
    ON highest_paying_skills.skills = in_demand_skills.skills
WHERE
    skill_count > 10
ORDER BY average_wage DESC,skill_count DESC

--ALTERNATIVELY--

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) as average_wage,
    COUNT(skills_job_dim.job_id) as skill_count
FROM
    skills_dim
INNER JOIN skills_job_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = True
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    average_wage DESC,
    skill_count DESC