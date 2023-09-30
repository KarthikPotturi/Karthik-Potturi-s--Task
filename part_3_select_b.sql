/*--------------*/	
Approach - 1
/*--------------*/
SELECT
    c.email,
    COUNT(DISTINCT lh.id) AS total_logins,
    COUNT(DISTINCT p.purchase_id) AS total_purchases
FROM
    cf_customer c
LEFT JOIN
    cf_login_history lh ON c.cust_id = lh.cust_id and lh.login_status = 'Y'
LEFT JOIN
    cf_purchase p ON c.cust_id = p.cust_id
GROUP BY
    c.email
ORDER BY
	total_logins desc;
	
/*--------------*/	
Approach - 2
/*--------------*/
dbo.getUserLoginCount and dbo.getUserPurchaseCount are Functions that return the counts
SELECT 
	email, 
	dbo.getUserLoginCount(cust_id) as Total_Logins, 
	dbo.getUserPurchaseCount(cust_id) as Total_Purchase
from cf_customer