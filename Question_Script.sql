/*
 * 1. otazka
 *  Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 */

CREATE OR REPLACE VIEW v_up_down AS
	WITH add_next_row AS (
		SELECT
			`year` ,
			salary ,
			name_of_industry, 
			LEAD(salary) OVER (ORDER BY name_of_industry, `year`  ) AS next_row
		FROM t_Jan_Pospisil_project_SQL_primary_final
		)
	SELECT `year`,
			name_of_industry ,
			CASE
				WHEN salary  < next_row THEN 1
				WHEN salary  = next_row THEN 0
				ELSE -1
			END AS 'up_down'
	FROM add_next_row

SELECT
	name_of_industry AS 'Industry_branch_name',
	CASE 
		WHEN SUM(up_down) > 0 THEN 'V průběhu let mzdy stoupají'
		WHEN SUM(up_down) < 0 THEN 'V průběhu let mzdy klesají'
		ELSE 'V průběhu let jsou mzdy stejné'
	END AS 'result_between_2006/2018'
FROM v_up_down 
GROUP BY name_of_industry;




/* 
 * 2. otazka
 *  Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */ 

SELECT
	`year`,
	ROUND(AVG(salary)),
	ROUND(AVG(salary) / value)
FROM t_Jan_Pospisil_project_SQL_primary_final
WHERE product_code IN ('111301','114201')
AND `year` IN ('2006','2018')
GROUP BY `year`,product_code 

SELECT
	`year`,
	ROUND(AVG(salary)) AS 'AVG salary',
	CASE 
		WHEN product_code = 111301 THEN CONCAT(ROUND(AVG(salary)/ value), ' kg chleba za prumerny plat')
		WHEN product_code = 114201 THEN CONCAT(ROUND(AVG(salary)/ value), ' l mleka za prumerny plat')
	END AS 'result'
FROM t_Jan_Pospisil_project_SQL_primary_final
WHERE product_code IN ('111301','114201')
AND `year` IN ('2006','2018')
GROUP BY `year`,product_code ;

/*
 * 3. otazka 
 * Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */
WITH help_tab AS ( 
	SELECT 
		`year` ,
		product_name ,
		value ,
		LEAD(value) OVER (ORDER BY product_name, `year`) AS 'value2'
FROM t_Jan_Pospisil_project_SQL_primary_final
GROUP BY product_name, `year` )
SELECT
	product_name ,
	SUM(ROUND(((value2 - value) / value ) *100 , 2)) AS 'sum_growth_percent' 
FROM help_tab
WHERE year != 2018
GROUP BY product_name 
ORDER BY sum_growth_percent ASC
;

/*
 * 4. otazka 
 * Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 */
CREATE OR REPLACE VIEW v_food_growth AS 
WITH help_tab AS ( 
	SELECT 
		`year` ,
		product_name ,
		value ,
		LEAD(value) OVER (ORDER BY product_name, `year`) AS 'value2'
FROM t_Jan_Pospisil_project_SQL_primary_final
GROUP BY product_name, `year` )
SELECT
	(`year` + 1) AS 'year' ,
	ROUND(AVG(ROUND(((value2 - value) / value ) *100 , 2)),2) AS 'growth_percent' 
FROM help_tab
WHERE`year` != 2018
GROUP BY (`year` + 1)
;
SELECT *
FROM v_food_growth ;
/*
 * 5. otazka
 * Má výška HDP vliv na změny ve mzdách a cenách potravin?
 *  Neboli, pokud HDP vzroste výrazněji v jednom roce,
 *  projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */

WITH growth_tab AS (
	SELECT 
		`year`,
		GDP ,
		LEAD(GDP) OVER (ORDER BY `year`) AS 'GDP_nxt_row' 
	FROM t_Jan_Pospisil_project_SQL_primary_final
	GROUP BY `year`)
SELECT 
	(gt.`year`+ 1) AS 'year',
	AVG(prim.salary),
	vfg.growth_percent , 
	ROUND(((GDP_nxt_row - gt.GDP) / gt.GDP) * 100 , 2) AS GDP_growth
FROM growth_tab gt
JOIN v_food_growth vfg 
ON (gt.`year`+ 1) = vfg.`year`
JOIN t_Jan_Pospisil_project_SQL_primary_final prim
ON (gt.`year`+ 1) = prim.`year` 
GROUP BY (`year`+ 1)