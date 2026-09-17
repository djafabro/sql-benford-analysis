-- Run after 00_setup.sql. Safe to rerun: replaces views only.
DROP VIEW IF EXISTS benford_results;
DROP VIEW IF EXISTS eligible_transactions;

-- First significant digit: integer cents work for positive two-decimal currency.
-- Multiplying euros by 100 does not change the first significant digit.
CREATE VIEW eligible_transactions AS
SELECT *, CAST(SUBSTR(CAST(amount_cents AS TEXT),1,1) AS INTEGER) AS first_digit
FROM transactions
WHERE amount_cents > 0 AND currency = 'EUR' AND record_type = 'invoice';

CREATE VIEW benford_results AS
WITH scenarios AS (
 SELECT DISTINCT scenario FROM eligible_transactions
), totals AS (
 SELECT scenario, COUNT(*) AS n FROM eligible_transactions GROUP BY scenario
), counts AS (
 SELECT scenario, first_digit, COUNT(*) AS observed_count
 FROM eligible_transactions GROUP BY scenario, first_digit
)
SELECT s.scenario, e.digit, t.n,
 COALESCE(c.observed_count,0) AS observed_count,
 e.probability AS expected_share,
 1.0*COALESCE(c.observed_count,0)/t.n AS observed_share,
 100.0*(1.0*COALESCE(c.observed_count,0)/t.n-e.probability) AS gap_percentage_points
FROM scenarios s CROSS JOIN benford_expected e
JOIN totals t ON t.scenario=s.scenario
LEFT JOIN counts c ON c.scenario=s.scenario AND c.first_digit=e.digit;

-- Nine digits per scenario, including digits with no observations.
SELECT scenario, digit, observed_count,
 ROUND(100*observed_share,2) AS observed_percent,
 ROUND(100*expected_share,2) AS expected_percent,
 ROUND(gap_percentage_points,2) AS gap_pp
FROM benford_results ORDER BY scenario,digit;
