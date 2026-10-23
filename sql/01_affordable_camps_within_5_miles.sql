/*
Analysis 01: Affordable Summer Camps Near Cambridge

Business Question:
Which summer camp programs cost less than $600 per week
and are located within 5 miles of central Cambridge?

Methods:
- JOIN programs with all_camps
- Calculate straight-line geographic distance
- Filter programs by weekly price and distance
- Use a CTE to organize the analysis

Limitations:
- Distances are straight-line, not driving distances.
- Reference location: 42.3736, -71.1097 (Cambridge, MA)
- Results do not account for age eligibility,
  specific summer weeks, or registration availability.
- Prices reflect the source dataset and may change.
*/

WITH camp_distances AS (
    SELECT
        p.program_id,
        c.camp_name,
        p.program_name,
        p.program_type,
        p.price_per_week,
        p.latitude,
        p.longitude,
        3959 * ACOS(
            LEAST(1.0, GREATEST(-1.0,
                COS(RADIANS(42.3736)) *
                COS(RADIANS(p.latitude)) *
                COS(RADIANS(p.longitude) - RADIANS(-71.1097)) +
                SIN(RADIANS(42.3736)) *
                SIN(RADIANS(p.latitude))
            ))
        ) AS distance_miles
    FROM public.programs p
    JOIN public.all_camps c
        ON p.camp_id = c.camp_id
    WHERE p.price_per_week < 600
      AND p.latitude IS NOT NULL
      AND p.longitude IS NOT NULL
)

SELECT
    camp_name,
    program_name,
    program_type,
    price_per_week,
    ROUND(distance_miles::numeric, 2) AS distance_miles
FROM camp_distances
WHERE distance_miles <= 5
ORDER BY distance_miles, price_per_week;
