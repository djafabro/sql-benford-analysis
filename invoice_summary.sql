SELECT
    scenario,
    COUNT(*) AS invoice_count,
    MIN(amount_cents) / 100.0 AS lowest_eur,
    MAX(amount_cents) / 100.0 AS highest_eur,
	ROUND(AVG(amount_cents) / 100.0, 2) AS average_eur,
	ROUND(SUM(amount_cents) / 100.0, 2) AS total_eur
FROM transactions
WHERE currency = 'EUR'
  AND record_type = 'invoice'
  AND amount_cents > 0
GROUP BY scenario
HAVING SUM(amount_cents) / 100.0 > 40000000;