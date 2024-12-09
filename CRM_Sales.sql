-- Creating the database 'crm_sales'
CREATE DATABASE crm_sales;

-- Creating necessary tables and columns while defining relevant datatypes in the database and giving appropiate table referencing hwere needed
CREATE TABLE accounts (
	account VARCHAR(255) PRIMARY KEY,
	sector VARCHAR(255),
	year_established INT,
	revenue DECIMAL(10, 2),
	employees INT,
	office_location VARCHAR(255),
	subsidiary_of VARCHAR(255)
);

CREATE TABLE products (
	product VARCHAR(255) PRIMARY KEY,
	series VARCHAR(255),
	sales_price INT
);

CREATE TABLE sales_teams (
	sales_agent VARCHAR(255) PRIMARY KEY,
	manager VARCHAR(255),
	regional_office VARCHAR(255)
);

CREATE TABLE sales_pipeline (
	opportunity_id VARCHAR(255) PRIMARY KEY,
	sales_agent VARCHAR(255),
	product VARCHAR(255),
	account VARCHAR(255),
	deal_stage VARCHAR(50),
	engage_date VARCHAR(150),
	close_date VARCHAR(150),
	close_value INT,
	FOREIGN KEY (sales_agent)
	REFERENCES sales_teams(sales_agent),
	FOREIGN KEY (account) 
	REFERENCES accounts(account),
	FOREIGN KEY (account)
	REFERENCES accounts(account)
);

-- The need to alter the datatype for the date related columns due to the date format not in line with the acceptable PostgreSQL format
ALTER TABLE sales_pipeline
ALTER COLUMN engage_date
TYPE DATE USING engage_date::DATE;

ALTER TABLE sales_pipeline
ALTER COLUMN close_date
TYPE DATE USING close_date::DATE;

-- Total revenue and win rate per sales agent
SELECT
	st.sales_agent,
	st.manager,
	SUM(sp.close_value) AS total_revenue,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) AS won_count,
	COUNT(sp.opportunity_id) AS opportunity_count,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) * 100.00 / COUNT(sp.opportunity_id) AS win_rate 
FROM 
	sales_pipeline AS sp
JOIN 
	sales_teams AS st 
ON 
	sp.sales_agent = st.sales_agent
WHERE 
	sp.deal_stage IN ('Won', 'Lost')
GROUP BY 
	st.sales_agent, st.manager
ORDER BY 
	total_revenue 
DESC;

-- Total revenue and win rate per sales team and agent
SELECT
	st.*,
	SUM(sp.close_value) AS total_revenue,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) AS won_count,
	COUNT(sp.opportunity_id) AS opportunity_count,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) * 100.00 / COUNT(sp.opportunity_id) AS win_rate 
FROM 
	sales_pipeline AS sp
JOIN 
	sales_teams AS st 
ON 
	sp.sales_agent = st.sales_agent
WHERE 
	sp.deal_stage IN ('Won', 'Lost')
GROUP BY 
	st.sales_agent, 
	st.manager
ORDER BY 
	total_revenue 
DESC;

-- Total revenue and win rate per sales agent
SELECT 
	st.sales_agent,
	SUM(sp.close_value) AS total_revenue,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) * 100.00 / COUNT(sp.opportunity_id) AS win_rate
FROM 
	sales_pipeline AS sp
JOIN 
	sales_teams AS st 
ON 
	sp.sales_agent = st.sales_agent
WHERE 
	sp.deal_stage IN ('Won', 'Lost')
GROUP BY 
	st.sales_agent
ORDER BY 
	total_revenue 
DESC;

-- Average deal cycle time (days between creation and close date)
SELECT 
	AVG(sp.close_date - sp.engage_date) AS avg_deal_cycle_time_days
FROM 
	sales_pipeline AS sp
WHERE 
	sp.deal_stage IN ('Won', 'Lost');

-- Quarterly performance metrics (total revenue, deals closed, win rate)
SELECT 
	DATE_PART('year', sp.close_date) AS year,
	DATE_PART('quarter', sp.close_date) AS quarter,
	SUM(sp.close_value) AS total_revenue,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) AS deals_closed,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) * 100.00 / COUNT(sp.opportunity_id) AS win_rate
FROM 
	sales_pipeline AS sp
WHERE 
	sp.deal_stage IN ('Won', 'Lost')
GROUP BY 
	DATE_PART('year', sp.close_date), DATE_PART('quarter', sp.close_date)
ORDER BY 
	year, 
	quarter;

-- Product performance metrics (win rate, revenue contribution)
SELECT 
	p.product,
	COUNT(CASE WHEN sp.deal_stage = 'Won' THEN 1 END) * 100.00/ COUNT(sp.opportunity_id) AS win_rate,
	SUM(sp.close_value) AS revenue_contribution,
	SUM(sp.close_value) * 100.00 / (SELECT SUM(close_value) FROM sales_pipeline WHERE deal_stage = 'Won') AS revenue_percentage
FROM 
	sales_pipeline AS sp
JOIN 
	products AS p 
ON 
	sp.product = p.product
WHERE 
	sp.deal_stage IN ('Won', 'Lost')
GROUP BY 
	p.product
ORDER BY 
	revenue_contribution 
DESC;

-- Creating views from each tables for data importing into Power BI
CREATE VIEW sales_pipeline_view AS
SELECT
	sp.opportunity_id,
	sp.sales_agent,
	sp.product,
	sp.account,
	sp.deal_stage,
	sp.engage_date,
	sp.close_date,
	sp.close_value
FROM
	sales_pipeline AS sp;

CREATE VIEW sales_teams_view AS
SELECT
	st.sales_agent,
	st.manager,
	st.regional_office
FROM
	sales_teams AS st;

CREATE VIEW products_view AS
SELECT
	p.product,
	p.series,
	p.sales_price
FROM
	products AS p;

CREATE VIEW accounts_view AS
SELECT
	a.account,
	a.sector,
	a.year_established,
	a.revenue,
	a.employees,
	a.office_location,
	a.subsidiary_of
FROM 
	accounts AS a;