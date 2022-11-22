/*
 * 1. otazka
 *  Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

SELECT 
	`year`,
	name_of_industry,
	salary,
	ROUND((((LEAD(salary) OVER (PARTITION BY name_of_industry ORDER BY name_of_industry, year)) - salary) / salary) * 100, 2) AS 'perecent_salary_growth'
FROM t_Jan_Pospisil_project_SQL_primary_final 
GROUP BY name_of_industry, `year`;




/* 
 * 2. otazka
 *  Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */ 


SELECT
	`year`,
	ROUND(AVG(salary)) AS 'avg_salary',
	CASE 
		WHEN cpc.name LIKE '%Chléb%' THEN CONCAT(ROUND(AVG(salary)/ value), ' kg chleba za prumerny plat')
		WHEN cpc.name LIKE '%Mléko%' THEN CONCAT(ROUND(AVG(salary)/ value), ' l mleka za prumerny plat')
	END AS 'result'
FROM t_Jan_Pospisil_project_SQL_primary_final prim
JOIN czechia_price_category cpc
ON prim.product_code = cpc.code 
WHERE product_code IN('111301', '114201')
AND `year` IN ('2006', '2018')
GROUP BY `year`, product_code;


/*
 * 3. otazka 
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */
WITH help_tab AS ( 
	SELECT 
		`year`,
		product_name,
		value,
		LEAD(value) OVER(ORDER BY product_name, `year`) AS 'value2'
FROM t_Jan_Pospisil_project_SQL_primary_final
GROUP BY product_name, `year` )
SELECT
	product_name,
	SUM(ROUND(((value2 - value) / value ) *100, 2)) AS 'sum_growth_percent' 
FROM help_tab
WHERE year != 2018
GROUP BY product_name  
ORDER BY sum_growth_percent ASC;


/*
 * 4. otazka 
 * Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 */
CREATE OR REPLACE VIEW v_food_growth AS 
WITH help_tab AS ( 
	SELECT
		`year`,
		product_name,
		value,
		LEAD(value) OVER (ORDER BY product_name, `year`) AS 'value2'
FROM t_Jan_Pospisil_project_SQL_primary_final
GROUP BY product_name, `year` )
SELECT
	(`year` + 1) AS 'year',
	ROUND(AVG(ROUND(((value2 - value) / value ) *100 , 2)),2) AS 'food_growth_percent' 
FROM help_tab
WHERE`year` != 2018
GROUP BY (`year` + 1);

CREATE OR REPLACE VIEW v_salary_growth AS
SELECT 
	`year`,
	ROUND(((LEAD(AVG(salary)) OVER (ORDER BY `year`) - AVG(salary)) / AVG(salary)) * 100,2)AS 'growth'
FROM t_Jan_Pospisil_project_SQL_primary_final
GROUP BY `year`;

SELECT
	fg.`year`,
	fg.food_growth_percent,
	sg.growth AS 'salary_growth_percent'
FROM v_food_growth fg
LEFT JOIN v_salary_growth sg
ON fg.`year` = sg.`year`;


/*
 * 5. otazka
 * Má výška HDP vliv na změny ve mzdách a cenách potravin?
 *  Neboli, pokud HDP vzroste výrazněji v jednom roce,
 *  projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */

WITH growth_tab AS (
	SELECT 
		`year`,
		GDP,
		LEAD(GDP) OVER (ORDER BY `year`) AS 'GDP_nxt_row' 
	FROM t_Jan_Pospisil_project_SQL_primary_final
	GROUP BY `year`)
SELECT 
	(gt.`year`+ 1) AS 'year',
	ROUND(AVG(prim.salary),2) AS 'avg_salary',
	vfg.food_growth_percent, 
	ROUND(((GDP_nxt_row - gt.GDP) / gt.GDP) * 100 , 2) AS 'GDP_growth'
FROM growth_tab gt
JOIN v_food_growth vfg 
ON (gt.`year`+ 1) = vfg.`year`
JOIN t_Jan_Pospisil_project_SQL_primary_final prim
ON (gt.`year`+ 1) = prim.`year` 
GROUP BY (`year`+ 1);
