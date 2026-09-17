-- Compare a specific amount band, not all amounts beginning with 7.
SELECT scenario, COUNT(*) AS total_invoices,
 SUM(CASE WHEN amount_cents BETWEEN 70000 AND 79999 THEN 1 ELSE 0 END) AS invoices_in_band,
 ROUND(100.0 * SUM(CASE WHEN amount_cents BETWEEN 70000 AND 79999 THEN 1 ELSE 0 END) / COUNT(*), 2) AS percent_in_band
FROM transactions
WHERE currency='EUR' AND record_type='invoice' AND amount_cents>0
GROUP BY scenario;

-- Investigate duplicate pairs before deleting records. Expected: zero rows.
SELECT supplier_id, invoice_reference, COUNT(*) AS occurrences
FROM transactions
GROUP BY supplier_id, invoice_reference
HAVING COUNT(*)>1;

-- Safe duplicate demonstration: changes only the query result.
WITH practice_data AS (
 SELECT supplier_id, invoice_reference FROM transactions
 UNION ALL
 SELECT supplier_id, invoice_reference FROM transactions WHERE transaction_id=1
)
SELECT supplier_id, invoice_reference, COUNT(*) AS occurrences
FROM practice_data GROUP BY supplier_id, invoice_reference HAVING COUNT(*)>1;

-- Unmatched records in a deliberately incomplete fictional lookup.
WITH supplier_names AS (
 SELECT 'S001' AS supplier_id, 'Example Supplier A' AS supplier_name
 UNION ALL SELECT 'S002', 'Example Supplier B'
)
SELECT t.transaction_id,t.supplier_id,s.supplier_name,t.amount_cents/100.0 AS amount_eur
FROM transactions t LEFT JOIN supplier_names s ON t.supplier_id=s.supplier_id
WHERE t.transaction_id BETWEEN 1 AND 5 AND s.supplier_id IS NULL
ORDER BY t.transaction_id;

-- Rank before filtering: window functions need the separate query level.
WITH ranked_digits AS (
 SELECT scenario,digit,gap_percentage_points,
 RANK() OVER (PARTITION BY scenario ORDER BY ABS(gap_percentage_points) DESC) AS gap_rank
 FROM benford_results
)
SELECT scenario,digit,ROUND(gap_percentage_points,2) AS gap_pp,gap_rank
FROM ranked_digits WHERE gap_rank<=3 ORDER BY scenario,gap_rank;
