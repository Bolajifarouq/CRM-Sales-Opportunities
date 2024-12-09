# CRM-Sales-Opportunities
Case Study Background
TechSphere Solutions operates in a highly competitive B2B environment. The company sells computer hardware, including servers, desktops, laptops, and networking equipment, to a variety of mid-sized and enterprise clients.

CRM Sales Opportunities 
Data Overview
•	Identified the key tables (sales_pipeline, products, accounts, sales_teams) and understood their structure and relationships using the data dictionary.
•	Highlighted essential fields, such as sales_agent, product, close_value, account, and deal_stage.
Data Preparation
•	Created a comprehensive SQL VIEW to consolidate data from all tables, ensuring essential fields like revenue, deal stages, and product details are included.
•	Addressed data formatting inconsistencies (e.g., date formats) during the import process to ensure compatibility with SQL standards (e.g., converting MM/DD/YYYY to YYYY-MM-DD).
•	Addressed null dates in engage_date and close_date to ensure comprehensive filtering while retaining deal stages like "Engaging"
•	Linked Sales_pipeline to Accounts, Products, and Sales_teams via appropriate keys (e.g., account, product, sales_agent).
Key Metrics Calculation
SQL
•	Used the SQL queries to calculate critical metrics, including:
o	Total revenue by team and agent.
o	Win rates per team and product.
o	Average deal cycle time.
o	Quarterly and product performance metrics.
Power BI
•	Defined relationships across tables:
o	Revenue trends.
o	Agent and team performance.
o	Deal stage progressions.
o	Product contribution analysis.

Data Export
•	Exported the SQL VIEW to a compatible format (e.g., direct connection & importation) for further analysis in Power BI.
Visualization Design:
•	Created a dashboard focused on the following:
o	Performance Metrics: KPIs like total revenue, deal count, and average deal size.
o	Quarterly Trends: Line charts for revenue and deal volume trends.
o	Agent and Team Insights: Bar charts for individual and team contributions.
o	Pipeline Status: Tables summarizing opportunities by stage and deal progress.
•	Incorporated slicers for sales manager, region and time period filters to make the dashboard interactive.
•	Shared insights with stakeholders, focusing on performance optimization, deal conversion strategies, and market trends based on the analysis.
Recommendations Based on the Sales Dataset Analysis
	Provide targeted training and mentoring to agents or teams with lower win rates
	Recognize high-performing teams and replicate their strategies across other teams.
	Focus on accounts in the “Prospecting” and “Engaging” stages with high potential revenue but lower conversion rates.
