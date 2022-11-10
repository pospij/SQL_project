/* Otazka 1 Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*/
CREATE OR REPLACE VIEW v_up_down AS
	WITH add_next_row AS (
		SELECT 
			cpib.name,
			cp.payroll_year,
			cp.value,
			LEAD(cp.value) OVER (ORDER BY cp.industry_branch_code, cp.payroll_year) AS next_row
		FROM czechia_payroll cp 
		JOIN czechia_payroll_industry_branch cpib 
		ON cp.industry_branch_code = cpib.code 
		AND cp.value_type_code = 5958
		)
	SELECT payroll_year ,
			name,
			CASE
				WHEN value < next_row THEN 1
				WHEN value = next_row THEN 0
				ELSE -1
			END AS 'up_down'
	FROM add_next_row

SELECT
	name AS 'Industry_branch_name',
	CASE 
		WHEN SUM(up_down) > 0 THEN 'V průběhu let mzdy stoupají'
		WHEN SUM(up_down) < 0 THEN 'V průběhu let mzdy klesají'
		ELSE 'V průběhu let jsou mzdy stejné'
	END AS 'result_between_2000/2021'
FROM v_up_down 
GROUP BY name;



SELECT * FROM t_Jan_Pospisil_project_SQL_primary_final 

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
GROUP BY `year`,product_code 