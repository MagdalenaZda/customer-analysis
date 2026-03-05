CREATE TABLE tmp_marketing (
    id TEXT,
    year_birth TEXT,
    education TEXT,
    marital_status TEXT,
    income TEXT,
    kidhome TEXT,
    teenhome TEXT,
    dt_customer TEXT,
    recency TEXT,
    mntwines TEXT,
    mntfruits TEXT,
    mntmeatproducts TEXT,
    mntfishproducts TEXT,
    mntsweetproducts TEXT,
    mntgoldprods TEXT,
    numdealspurchases TEXT,
    numwebpurchases TEXT,
    numcatalogpurchases TEXT,
    numstorepurchases TEXT,
    numwebvisitsmonth TEXT,
    acceptedcmp3 TEXT,
    acceptedcmp4 TEXT,
    acceptedcmp5 TEXT,
    acceptedcmp1 TEXT,
    acceptedcmp2 TEXT,
    complain TEXT,
    z_costcontact TEXT, 
    z_revenue TEXT,     
    response TEXT
);


CREATE TABLE dim_customers (
	id INT PRIMARY KEY,
	year_birth INT,
	education VARCHAR(50),
	marital_status VARCHAR(50),
	income INT,
	kid_home INT,
	teen_home INT,
	dt_customer DATE,
	complain INT
);

CREATE TABLE fact_purchases (
	id INT REFERENCES dim_customers(id),
	mnt_wines INT,
	mnt_fruits INT,
	mnt_meat_products INT,
	mnt_fish_products INT,
	mnt_sweet_products INT,
	mnt_gold_prods INT,
	recency INT,
	num_web_purchases INT,
	num_catalog_purchases INT,
	num_store_purchases INT,
	num_web_visits_month INT
);

CREATE TABLE fact_promotions (
	id INT REFERENCES dim_customers(id),
	num_deals_purchases INT,
	accepted_cmp1 INT,
	accepted_cmp2 INT,
	accepted_cmp3 INT,
	accepted_cmp4 INT,
	accepted_cmp5 INT,
	response INT
);

DROP TABLE tmp;



INSERT INTO dim_customers (id,year_birth,education, marital_status ,income , kid_home, teen_home, dt_customer,complain)
SELECT 
	id::INT,
	year_birth::INT,
	education::VARCHAR(50), 
	marital_status::VARCHAR(50),
	income::INT,
	kidhome::INT,
	teenhome::INT,
	TO_DATE(dt_customer, 'DD-MM-YYYY'),
	complain::INT
FROM tmp_marketing;

INSERT INTO fact_purchases (id,mnt_wines,mnt_fruits,mnt_meat_products,mnt_fish_products,mnt_sweet_products,mnt_gold_prods,recency,num_web_purchases,num_catalog_purchases,num_store_purchases, num_web_visits_month)
SELECT
	id::INT,
	mntwines::INT,
	mntfruits::INT,
	mntmeatproducts::INT,
	mntfishproducts::INT,
	mntsweetproducts::INT,
	mntgoldprods::INT,
	recency::INT,
	numwebpurchases::INT,
	numcatalogpurchases::INT,
	numstorepurchases::INT,
	numwebvisitsmonth::INT
FROM tmp_marketing;

INSERT INTO fact_promotions (id,num_deals_purchases,accepted_cmp1,accepted_cmp2,accepted_cmp3,accepted_cmp4,accepted_cmp5,response)
SELECT
	id::INT,
	numdealspurchases::INT,
	acceptedcmp1::INT,
	acceptedcmp2::INT,
	acceptedcmp3::INT,
	acceptedcmp4::INT,
	acceptedcmp5::INT,
	response::INT,
FROM tmp_marketing;

ALTER TABLE dim_customers ADD COLUMN age_group VARCHAR(20);

UPDATE dim_customers
SET age_group = CASE
		WHEN (2026 - year_birth) < 40 THEN 'Young Adults'
		WHEN (2026 - year_birth) BETWEEN 40 AND 49 THEN 'Established Adults'
		WHEN (2026 - year_birth) BETWEEN 50 AND 59 THEN 'Mature Adults'
		ELSE 'Seniors'
	END
;

ALTER TABLE dim_customers ADD COLUMN income_segment VARCHAR(20);

UPDATE dim_customers
SET income_segment = CASE
	WHEN income < 30000 THEN 'Low'
		WHEN income BETWEEN 30000 AND 60000 THEN 'Average'
		WHEN income BETWEEN 60000 AND 100000 THEN 'High'
		WHEN income > 100000 THEN 'Top'
		ELSE 'Other'
	END 
;


CREATE OR REPLACE VIEW v_customer_golden_record AS
SELECT 
    c.id,
    (2026 - c.year_birth) AS age, 
	c.age_group,
    c.education,
    c.marital_status,
    c.income,
	c.income_segment,
    (c.kid_home + c.teen_home) AS total_children, 
    p.mnt_wines + p.mnt_fruits + p.mnt_meat_products + p.mnt_fish_products + p.mnt_sweet_products + p.mnt_gold_prods AS total_spent,
    pr.accepted_cmp1 + pr.accepted_cmp2 + pr.accepted_cmp3 + pr.accepted_cmp4 + pr.accepted_cmp5 AS total_campaigns_accepted,
    CASE WHEN c.complain = 1 THEN 'Yes' ELSE 'No' END AS complaint
FROM dim_customers c
LEFT JOIN fact_purchases p ON c.id = p.id
LEFT JOIN fact_promotions pr ON c.id = pr.id;


CREATE VIEW v_customer_engagement AS
SELECT 
    id,
    recency, 
    (num_web_purchases + num_catalog_purchases + num_store_purchases) AS total_transactions,
    num_web_visits_month,
    CASE 
        WHEN recency <= 30 THEN 'Active'
        WHEN recency <= 90 THEN 'At Risk'
        ELSE 'Churned' 
    END AS customer_status
FROM fact_purchases;


CREATE VIEW v_promotion_efficiency AS
SELECT 
    c.education,
    c.marital_status,
    SUM(pr.num_deals_purchases) AS total_deals,
    SUM(pr.response) AS total_conversions,
    AVG(c.income) AS avg_income_per_segment
FROM dim_customers c
JOIN fact_promotions pr ON c.id = pr.id
GROUP BY c.education, c.marital_status;

