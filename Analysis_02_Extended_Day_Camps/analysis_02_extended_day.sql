
-- =====================================================
-- ANALYSIS 02: EXTENDED-DAY SUMMER CAMP OPTIONS
-- Boston Summer Camps Database
-- =====================================================

-- BUSINESS QUESTION:
-- Which summer camp programs offer schedules compatible
-- with working parents, and how do their coverage hours
-- and standard weekly tuition compare?

-- QUALIFYING CRITERIA:
-- Start time before 9:00 AM
-- End time after 5:00 PM

-- DATA LIMITATION:
-- Weekly tuition represents standard program pricing.
-- Additional extended-care fees may not be included.


-- =====================================================
-- QUERY 1: MAIN ANALYSIS
-- Dataset used to create the Power BI dashboard
-- =====================================================

SELECT DISTINCT
    c.camp_id,
    p.program_id,
    c.camp_name,
    p.program_name,
    p.price_per_week AS standard_weekly_price,
    h.start_time,
    h.end_time,
    ROUND(
        EXTRACT(EPOCH FROM (h.end_time - h.start_time))
        / 3600, 2
    ) AS daily_coverage_hours
FROM all_camps AS c
JOIN programs AS p
    ON c.camp_id = p.camp_id
JOIN hours AS h
    ON p.program_id = h.program_id
WHERE h.start_time < TIME '09:00:00'
  AND h.end_time > TIME '17:00:00'
ORDER BY daily_coverage_hours DESC,
         standard_weekly_price ASC;


-- =====================================================
-- QUERY 2: VALIDATE MULTIPLE SCHEDULE RECORDS
-- Identify programs with multiple qualifying schedules
-- =====================================================

SELECT
    p.program_id,
    p.program_name,
    COUNT(*) AS qualifying_schedule_rows,
    COUNT(DISTINCT (h.start_time, h.end_time))
        AS unique_schedule_windows
FROM programs AS p
JOIN hours AS h
    ON p.program_id = h.program_id
WHERE h.start_time < TIME '09:00:00'
  AND h.end_time > TIME '17:00:00'
GROUP BY
    p.program_id,
    p.program_name
HAVING COUNT(*) > 1
ORDER BY qualifying_schedule_rows DESC;


-- =====================================================
-- QUERY 3: VALIDATE TUITION COMPLETENESS
-- Check whether qualifying programs have tuition data
-- =====================================================

SELECT
    COUNT(DISTINCT p.program_id)
        AS total_qualifying_programs,

    COUNT(DISTINCT p.program_id)
        FILTER (WHERE p.price_per_week IS NULL)
        AS missing_tuition_programs,

    COUNT(DISTINCT p.program_id)
        FILTER (WHERE p.price_per_week IS NOT NULL)
        AS programs_with_tuition

FROM programs AS p
JOIN hours AS h
    ON p.program_id = h.program_id
WHERE h.start_time < TIME '09:00:00'
  AND h.end_time > TIME '17:00:00';


-- =====================================================
-- QUERY 4: IDENTIFY PROGRAMS WITH MISSING TUITION
-- Returns programs where weekly tuition is NULL
-- =====================================================

SELECT DISTINCT
    c.camp_name,
    p.program_name,
    p.program_id
FROM all_camps AS c
JOIN programs AS p
    ON c.camp_id = p.camp_id
JOIN hours AS h
    ON p.program_id = h.program_id
WHERE h.start_time < TIME '09:00:00'
  AND h.end_time > TIME '17:00:00'
  AND p.price_per_week IS NULL
ORDER BY c.camp_name, p.program_name;


-- =====================================================
-- END OF ANALYSIS 02
-- =====================================================
