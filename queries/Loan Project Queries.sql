CREATE DATABASE IF NOT EXISTS loan_dashboard;
USE loan_dashboard;

CREATE TABLE loan_disbursement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_month DATE,
    aggregate_deposits DOUBLE,
    bank_credit DOUBLE,
    non_food_credit DOUBLE,
    govt_securities DOUBLE,
    borrowings_from_rbi DOUBLE,
    home_loans DOUBLE,
    personal_loans DOUBLE,
    gold_loans DOUBLE,
    education_loans DOUBLE
);


SELECT * FROM loan_disbursement;

-- Total loan disbursed (overall)
SELECT 
  SUM(home_loans) AS total_home,
  SUM(personal_loans) AS total_personal,
  SUM(gold_loans) AS total_gold,
  SUM(education_loans) AS total_education
FROM loan_disbursement;

-- Trend of total bank credit over time
SELECT report_month, bank_credit 
FROM loan_disbursement 
ORDER BY report_month;

-- calculation of difference in each loans from previous date... 
SELECT 
  report_month,
  
  home_loans,
  LAG(home_loans) OVER (ORDER BY report_month) AS prev_home_loans,
  ROUND(
    (home_loans - LAG(home_loans) OVER (ORDER BY report_month)) 
    / NULLIF(LAG(home_loans) OVER (ORDER BY report_month), 0) * 100, 2
  ) AS home_loan_pct_change,

  personal_loans,
  LAG(personal_loans) OVER (ORDER BY report_month) AS prev_personal_loans,
  ROUND(
    (personal_loans - LAG(personal_loans) OVER (ORDER BY report_month)) 
    / NULLIF(LAG(personal_loans) OVER (ORDER BY report_month), 0) * 100, 2
  ) AS personal_loan_pct_change,

  gold_loans,
  ROUND(
    (gold_loans - LAG(gold_loans) OVER (ORDER BY report_month)) 
    / NULLIF(LAG(gold_loans) OVER (ORDER BY report_month), 0) * 100, 2
  ) AS gold_loan_pct_change,

  education_loans,
  ROUND(
    (education_loans - LAG(education_loans) OVER (ORDER BY report_month)) 
    / NULLIF(LAG(education_loans) OVER (ORDER BY report_month), 0) * 100, 2
  ) AS education_loan_pct_change

FROM 
  loan_disbursement
ORDER BY 
  report_month;
