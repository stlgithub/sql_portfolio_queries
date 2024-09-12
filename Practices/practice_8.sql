SELECT
    job_postings_fact.job_id,
    skills_dim.skills,
    skills_dim.type
FROM
    job_postings_fact
LEFT JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    EXTRACT(QUARTER FROM job_posted_date) = 1
    AND job_postings_fact.salary_year_avg > 70000
GROUP BY
    job_postings_fact.job_id,
        skills_dim.type,
    skills_dim.skills
ORDER BY
    job_postings_fact.job_id