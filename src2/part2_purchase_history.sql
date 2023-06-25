CREATE OR REPLACE VIEW PurchaseHistory AS
    SELECT DISTINCT pi.customer_id
                  , t.transaction_id
                  , t.transaction_datetime
                  , p.group_id
                  , sum(s.sku_purchase_price * c2.sku_amount) AS Group_Cost
                  , sum(c2.sku_summ) AS Group_Summ
                  , sum(c2.sku_summ_paid) AS Group_Summ_Paid
    FROM personinformation AS pi
             JOIN cards c on pi.customer_id = c.customer_id
             JOIN transactions t on c.customer_card_id = t.customer_card_id
             JOIN checks c2 on t.transaction_id = c2.transaction_id
             JOIN productgrid p on p.sku_id = c2.sku_id
             JOIN stores s on s.transaction_store_id = t.transaction_store_id AND p.sku_id = s.sku_id
    GROUP BY pi.customer_id, t.transaction_id, t.transaction_datetime, p.group_id;

SELECT * FROM PurchaseHistory
