CREATE OR REPLACE VIEW v_cze_payroll AS (
SELECT cp.payroll_year,
	ind.name ,
	cp.value
	FROM czechia_payroll AS cp
JOIN czechia_payroll_industry_branch AS ind
	ON cp.industry_branch_code = ind.code
WHERE cp.value IS NOT NULL AND cp.value_type_code = 5958
GROUP BY ind.name ,cp.payroll_year);

CREATE OR REPLACE VIEW v_cze_food AS (
SELECT 
	cp.category_code,
	cpc.name,
	cpc.price_value,
	cpc.price_unit,
	cp.value,
	YEAR(cp.date_from) 
FROM czechia_price cp
JOIN czechia_price_category cpc 
ON cp.category_code  = cpc.code
GROUP BY cp.category_code,YEAR(cp.date_from));

CREATE OR REPLACE VIEW v_cze_GDP AS 
SELECT GDP ,
	`year` 
FROM economies
WHERE country LIKE '%Czech%' AND GDP IS NOT NULL;
SELECT * FROM v_cze_gdp;


CREATE TABLE IF NOT EXISTS t_Jan_Pospisil_project_SQL_primary_final AS
SELECT
	v_cze_payroll.payroll_year AS 'year',
	v_cze_payroll.name  AS 'name_of_industry',
	v_cze_payroll.value  AS 'salary',
	v_cze_food.name AS 'product_name',
	CONCAT(v_cze_food.price_value, v_cze_food.price_unit) AS 'unit',
	v_cze_food.value,
	v_cze_food.category_code AS 'product_code',
	v_cze_gdp.GDP 
FROM v_cze_payroll
LEFT JOIN v_cze_food 
ON v_cze_payroll.payroll_year = v_cze_food.`YEAR(cp.date_from)` 
JOIN v_cze_gdp
ON payroll_year = v_cze_gdp.year
WHERE payroll_year BETWEEN 2006 AND 2018
ORDER BY payroll_year;



CREATE TABLE IF NOT EXISTS t_Jan_Pospisil_project_SQL_secondary_final AS
SELECT ec.`year` ,
		cn.country ,
		ec.GDP,
		ec.population,
		ec.gini 
FROM economies ec
JOIN countries cn
ON ec.country = cn.country 
WHERE cn.continent LIKE 'Europe' AND ec.`year` BETWEEN 2006 AND 2018
ORDER BY country , `year`;