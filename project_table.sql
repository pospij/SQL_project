CREATE OR REPLACE VIEW v_cze_payroll AS (
SELECT cp.payroll_year,
	ind.name,
	cp.value,
	AVG(cp.value) AS 'avg_salary'
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
	AVG(cp.value) AS 'avg_price', 
	YEAR(cp.date_from) AS 'year'
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc 
ON cp.category_code  = cpc.code
GROUP BY cp.category_code, YEAR(cp.date_from));

CREATE OR REPLACE VIEW v_cze_GDP AS 
SELECT GDP ,
	`year` 
FROM economies
WHERE country LIKE '%Czech%' AND GDP IS NOT NULL;
SELECT * FROM v_cze_gdp;


CREATE TABLE IF NOT EXISTS t_Jan_Pospisil_project_SQL_primary_final AS
SELECT
	vcp.payroll_year AS 'year',
	vcp.name  AS 'name_of_industry',
	vcp.value  AS 'salary',
	vcf.name AS 'product_name',
	CONCAT(vcf.price_value, vcf.price_unit) AS 'unit',
	vcf.value,
	vcf.category_code AS 'product_code',
	vgdp.GDP,
	vcf.avg_price,
	vcp.avg_salary 
FROM v_cze_payroll AS vcp
LEFT JOIN v_cze_food AS vcf
ON vcp.payroll_year = vcf.year 
JOIN v_cze_gdp AS vgdp
ON payroll_year = vgdp.year
WHERE payroll_year BETWEEN 2006 AND 2018
ORDER BY payroll_year;



CREATE TABLE IF NOT EXISTS t_Jan_Pospisil_project_SQL_secondary_final AS
SELECT ec.`year`,
		cn.country,
		ec.GDP,
		ec.population,
		ec.gini 
FROM economies AS ec
JOIN countries AS cn
ON ec.country = cn.country 
WHERE cn.continent LIKE 'Europe' AND ec.`year` BETWEEN 2006 AND 2018
ORDER BY country , `year`;