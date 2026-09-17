-- Descriptive MAD: average absolute difference in proportions.
-- No automatic fraud label and no universal pass/fail threshold.
SELECT scenario, MAX(n) AS sample_size,
 ROUND(AVG(ABS(observed_share-expected_share)),5) AS mean_absolute_deviation
FROM benford_results GROUP BY scenario ORDER BY mean_absolute_deviation DESC;

-- Window function ranks digit-level deviations WITHIN each scenario.
SELECT scenario,digit,ROUND(gap_percentage_points,2) AS gap_pp,
 RANK() OVER (PARTITION BY scenario ORDER BY ABS(gap_percentage_points) DESC) AS review_rank
FROM benford_results ORDER BY scenario,review_rank;

-- A follow-up sample, NOT a list of fraudulent invoices.
SELECT transaction_id,supplier_id,invoice_reference,amount_cents/100.0 AS amount_eur
FROM eligible_transactions WHERE scenario='altered' AND first_digit=7
ORDER BY transaction_id LIMIT 20;
