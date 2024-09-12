--1--

SELECT
    salary_year_avg,
    salary_hour_avg,
    job_posted_date,
    job_schedule_type
FROM 
    job_postings_fact
WHERE
    --salary_hour_avg IS NOT NULL
    --AND 
    salary_year_avg IS NOT NULL
    AND job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type,
    salary_year_avg,
    salary_hour_avg,
    job_posted_date


--2--

SELECT
    COUNT(*),
    EXTRACT(MONTH FROM job_posted_date) as posted_month
FROM job_postings_fact
GROUP BY
    posted_month
ORDER BY
    posted_month


--3--

SELECT 
    company_dim.name,
    EXTRACT(QUARTER FROM job_posted_date) as quarter
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM job_posted_date) = 2
