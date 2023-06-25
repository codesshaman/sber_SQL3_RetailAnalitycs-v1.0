CREATE OR REPLACE VIEW Customer_Analytics AS
SELECT
  p.Customer_ID,
  ROUND(AVG(t.Transaction_Summ), 2) AS Customer_Average_Check,
  CASE
    WHEN AVG(t.Transaction_Summ) >= 300 THEN 'High'
    WHEN AVG(t.Transaction_Summ) >= 100 THEN 'Medium'
    ELSE 'Low'
  END AS Customer_Average_Check_Segment,
  ROUND(1 / AVG(DATE_PART('day', t.Transaction_DateTime - lag(t.Transaction_DateTime) OVER (PARTITION BY t.Customer_Card_ID ORDER BY t.Transaction_DateTime))), 2) AS Customer_Frequency,
  CASE
    WHEN 1 / AVG(DATE_PART('day', t.Transaction_DateTime - lag(t.Transaction_DateTime) OVER (PARTITION BY t.Customer_Card_ID ORDER BY t.Transaction_DateTime))) >= 0.5 THEN 'Often'
    WHEN 1 / AVG(DATE_PART('day', t.Transaction_DateTime - lag(t.Transaction_DateTime) OVER (PARTITION BY t.Customer_Card_ID ORDER BY t.Transaction_DateTime))) >= 0.2 THEN 'Occasionally'
    ELSE 'Rarely'
  END AS Customer_Frequency_Segment,
  DATE_PART('day', CURRENT_TIMESTAMP - MAX(t.Transaction_DateTime)) AS Customer_Inactive_Period,
  (COUNT(DISTINCT t.Transaction_ID) - COUNT(DISTINCT c.Transaction_ID))::DECIMAL / COUNT(DISTINCT t.Transaction_ID) * 100 AS Customer_Churn_Rate,
  CASE
    WHEN (COUNT(DISTINCT t.Transaction_ID) - COUNT(DISTINCT c.Transaction_ID))::DECIMAL / COUNT(DISTINCT t.Transaction_ID) * 100 >= 30 THEN 'High'
    WHEN (COUNT(DISTINCT t.Transaction_ID) - COUNT(DISTINCT c.Transaction_ID))::DECIMAL / COUNT(DISTINCT t.Transaction_ID) * 100 >= 10 THEN 'Medium'
    ELSE 'Low'
  END AS Customer_Churn_Segment,
  DENSE_RANK() OVER (ORDER BY AVG(t.Transaction_Summ) DESC) AS Customer_Segment,
  s.Store_ID AS Customer_Primary_Store
FROM Personal_Information p
LEFT JOIN Cards ca ON p.Customer_ID = ca.Customer_ID
LEFT JOIN Transactions t ON ca.Customer_Card_ID = t.Customer_Card_ID
LEFT JOIN Checks c ON t.Transaction_ID = c.Transaction_ID
LEFT JOIN Stores s ON t.Transaction_ID = s.Transaction_Store_ID
GROUP BY p.Customer_ID, s.Store_ID;
