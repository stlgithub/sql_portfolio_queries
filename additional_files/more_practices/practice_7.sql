--1--

SELECT
    COUNT(skills_job_dim.*) as skill_count,
    skills_dim.skills
FROM skills_job_dim
LEFT JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    skill_count DESC
LIMIT 5


--2--

SELECT 
    COUNT(job_postings_fact.*) AS job_count,
    company_dim.name,
    CASE
        WHEN COUNT(job_postings_fact.*) < 10 THEN 'Small'
        WHEN COUNT(job_postings_fact.*) > 9 AND COUNT(job_postings_fact.*) < 51 THEN 'Medium'
        WHEN COUNT(job_postings_fact.*) > 50 THEN 'Large'
    END
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
GROUP BY job_postings_fact.company_id,company_dim.name