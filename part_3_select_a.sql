select status as 'ACCOUNT_STATUS', count(cust_id) as 'NUMBER_OF_ACCOUNTS' from cf_customer group by status