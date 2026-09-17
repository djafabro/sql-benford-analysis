# Financial Data Quality and Benford Analysis with SQL

A guided SQL portfolio project by **djafabro**, using SQLite and synthetic invoice data.

## Business question

How can SQL identify unusual amount patterns while keeping data-quality checks and business explanations visible?

I analysed three synthetic populations of 5,000 eligible invoices each. The project covers filtering, aggregation, joins, common table expressions (CTEs), window functions, and interpreting digit distributions. It is a learning project, not a fraud-detection system.

## Key findings

| Scenario | Eligible invoices | Mean absolute deviation | Largest absolute digit gap |
|---|---:|---:|---|
| Baseline | 5,000 | 0.00204 | Digit 5: −0.54 percentage points |
| Altered | 5,000 | 0.04058 | Digit 7: +18.26 percentage points |
| Fixed prices | 5,000 | 0.09466 | Digit 4: +23.67 percentage points |

MAD is the mean absolute difference between observed and expected proportions across all nine digits. It is descriptive, not a fraud probability or a universal pass/fail measure.

In the altered dataset, **20.88%** of invoices fall between €700 and €799.99, compared with **1.36%** in the baseline. This amount-band comparison is distinct from the first-digit comparison: an amount such as €7,500 starts with 7 but falls outside that band.

The fixed-price population has the greatest deviation because it contains only €19.99, €29.99, and €49.99. Its pricing structure makes Benford an unsuitable benchmark. This illustrates why the largest deviation does not establish wrongdoing.

## Data-quality checks

- Reconciled **15,004 raw records = 15,000 included + 4 excluded**.
- Exclusions: one missing amount, one zero amount, one negative credit, and one USD invoice. Exclusion does not necessarily mean error.
- Confirmed all nine digit groups account for 100% of eligible records per scenario.
- Checked supplier/invoice-reference pairs: no duplicates in the original data.
- Practised detecting a temporary duplicate without modifying the saved database.
- Used LEFT JOIN and missing-match filtering with a temporary fictional supplier lookup.

## Run the project

1. Download this repository as a ZIP and extract it.
2. Open `benford.sqlite` in [DB Browser for SQLite](https://sqlitebrowser.org/).
3. In **Execute SQL**, open and run the numbered query files in `sql/`, starting with `01_explore.sql`.
4. Run `invoice_summary.sql` for invoice counts, minimums, maximums, averages, and totals. Its final HAVING condition demonstrates filtering to totals above €40 million.

The supplied database already includes the data and analysis views. `sql/00_setup.sql` is only for building a NEW empty database; do not run it against the supplied database. `sql/02_benford.sql` recreates the analysis views and can be rerun.

## Files

- `benford.sqlite`: synthetic records, expected probabilities, and analysis views.
- `sql/`: commented setup, exploration, Benford comparison, review, and follow-up queries.
- `invoice_summary.sql`: summary query practised during the guided learning sessions.
- `FINDINGS.md`: reference results, interpretation, and limitations.

## How the data were constructed

All records are fictional; no employer or client records are included. Baseline amounts were deliberately generated with log-uniform magnitudes across five orders of magnitude. The altered sample replaces 1,000 amounts with values from €700 to €799.99. Fixed prices use three values. Four extra records demonstrate exclusions. Supplier assignments are artificial.

The populations are separate synthetic samples, not the same invoices measured before and after alteration. The simulation demonstrates query behaviour; it does not measure real-world detection accuracy. Stored amounts are integer cents. Multiplying positive EUR amounts by 100 preserves the first significant digit.

## Limitations and review approach

Before applying Benford to real data, understand how the amounts are generated, pricing restrictions, currencies, sample sizes, and business processes. A wide range alone does not guarantee a Benford fit. Assigned identifiers should not be tested as if they were naturally varying amounts. Digit-level deviations may warrant further review when the benchmark is appropriate; they do not identify fraudulent invoices by themselves.

## Learning and AI assistance

AI assisted with the synthetic dataset, starter scripts, documentation, and guided explanations. I practised running and modifying SQL queries, worked through errors, and interpreted results during guided learning sessions. This repository demonstrates foundational SQL project experience, not professional database engineering or independent fraud investigation. Python is a separate planned learning extension and is not claimed as completed work here.

## References

- [SQLite SQL documentation](https://sqlite.org/lang.html)
- [SQLite window functions](https://sqlite.org/windowfunctions.html)
- [ACFE: Benford’s law and screening](https://www.acfe.com/fraud-resources/fraud-examiner-archives/fraud-examiner-article?s=benfords-law-how-to-use-it-to-spot-fraud)
