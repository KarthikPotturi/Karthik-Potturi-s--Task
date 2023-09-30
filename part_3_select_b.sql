/*--------------*/	
Approach - 1
/*--------------*/
SELECT
    c.email as EMAIL,
    COUNT(DISTINCT lh.id) AS TOTAL_LOGINS,
    COUNT(DISTINCT p.purchase_id) AS TOTAL_PURCHASES
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
	email as EMAIL, 
	dbo.getUserLoginCount(cust_id) as TOTAL_LOGINS, 
	dbo.getUserPurchaseCount(cust_id) as TOTAL_LOGINS
from cf_customer
