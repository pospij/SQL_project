# SQL_project
## Engeto data acedemy project 1

-----

#####  Projekt se zabývá životní úrovní občanů a dostupností základních potravin.

----

### Jak začít
Jako první se musí spustit skript "project_table.sql", pro vytvoření tabulek obsahující potřebná data. \
Nasledně pomocí skriptu "Question_Script.sql" a spuštění jednotlivých dotazů, můžeme odpovědet, \
na jednotlivé výzkumné otázky.

-----

#### project_table.sql

Datové podklady pro porovnání  dostupnosti potravin na základě průměrných příjmů za určité časové období.\
Dodatečná data pro evropské státy, obsahující HDP, GINI a populaci ve stejném časovém období.

Časové období je mezi rokem 2006 a 2018.\
Pro jiné roky chybí data ohledně potravin.

-----


#### Question_Script.sql
Výzkumné otázky a odpovědi 

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
- Dle dostupných dat můžeme říct že v průběhu let mzdy stoupají


2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
- Za  rok 2006 si za průměrný plat je možné koupit 1139 kg chleba a 1374 l mléka.
- Za rok 2018 si za průměrný plat je možné koupit 1297 kg chleba a 1646 l mléka.



3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
- V časovém období jsme zaznamenali nejnižší procentuální nárůst u Cukr krystalový -2,48%



4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
- Dle dostupných dat žádném roce nebyl růst cen potravin výrazně vyšší než růst mezd.



5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
- Z dostupných dat můžeme říct, pokud nám HDP opakovaně klesá, projeví se to na poklesu průměrné mzdy.\
V roce 2012 a 2013 máme pokles HDP, průměrná mzda v roce 2013 nám klesla.