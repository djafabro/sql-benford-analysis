# Findings: SQL and Benford’s law

**Synthetic learning project — no real company records and no fraud findings.**

The analysis screened 15,004 records and included 15,000 positive EUR invoices. Four records were excluded: one missing amount, one zero, one negative credit, and one USD invoice. Credits and other currencies would need separately justified treatment in a real engagement.

| Scenario | Eligible records | Mean absolute deviation (proportions) |
|---|---:|---:|
| altered | 5,000 | 0.04058 |
| baseline | 5,000 | 0.00204 |
| fixed_price | 5,000 | 0.09466 |

The baseline was deliberately generated with log-uniform magnitudes; closeness to Benford is an expected property of the simulation. In the altered scenario, 1,000 of 5,000 amounts were deliberately replaced with values from EUR 700.00 to EUR 799.99. The observed first-digit-7 share is 24.06%, compared with a Benford expectation of 5.80%.

The fixed-price scenario uses only EUR 19.99, 29.99, and 49.99. It has a large deviation for a legitimate structural reason. It is an intentionally unsuitable population for Benford screening: it illustrates why deviation is not evidence of fraud.

## Interpretation
This demonstrates SQL data preparation and a descriptive comparison. It does not validate a fraud-detection model. These are independent synthetic populations, not a controlled before-and-after experiment on identical records. No accuracy, fraud probability, statistical significance, or real-world detection claim is made. MAD is descriptive; no universal threshold is applied.

Before using real records, understand pricing, minimum/maximum constraints, currency, duplicate handling, period coverage and the process generating amounts. Do not test assigned identifiers such as invoice numbers. A flagged digit describes a group, not the legitimacy of any individual transaction. Follow up with source documents and business explanations.

## Sources
- [ACFE: Benford’s law](https://www.acfe.com/fraud-resources/fraud-examiner-archives/fraud-examiner-article?s=benfords-law-how-to-use-it-to-spot-fraud)
- [SQLite scalar functions](https://www.sqlite.org/lang_corefunc.html)
- [SQLite window functions](https://www.sqlite.org/windowfunctions.html)

Prepared with AI assistance as a learning scaffold. Learner interpretation and independent extensions should be added before presenting this as completed personal work.
