-- Run each SELECT separately and predict its result first.
SELECT * FROM transactions LIMIT 10;

-- COUNT(*) counts all rows; COUNT(column) ignores NULL values.
SELECT scenario, COUNT(*) AS rows, COUNT(amount_cents) AS nonmissing_amounts,
 MIN(amount_cents)/100.0 AS minimum_eur_or_usd,
 MAX(amount_cents)/100.0 AS maximum_eur_or_usd
FROM transactions GROUP BY scenario;

-- Mutually exclusive reasons: do not silently delete exceptions.
SELECT CASE WHEN amount_cents IS NULL THEN 'Missing amount'
 WHEN amount_cents <= 0 THEN 'Zero or negative amount'
 WHEN currency <> 'EUR' THEN 'Other currency'
 WHEN record_type <> 'invoice' THEN 'Other record type'
 ELSE 'Included' END AS decision, COUNT(*) AS rows
FROM transactions GROUP BY decision;

-- Duplicate invoice references: none in this teaching dataset.
SELECT supplier_id, invoice_reference, COUNT(*) AS occurrences
FROM transactions GROUP BY supplier_id, invoice_reference HAVING COUNT(*)>1;
