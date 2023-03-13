-- SELECT ALL THE RECORDS 
select * from Portfolio_SQL..COVID_DEATH_SPL order by 3,4


--SELECT THE DATA WE ARE GOING TO BE USING 

select date,location,population,total_cases,new_cases,total_deaths
from Portfolio_SQL..COVID_DEATH_SPL 
order by 1,2



--Convertion to int from varachar

ALTER TABLE Portfolio_SQL..COVID_DEATH_SPL
ALTER COLUMN total_cases float;

ALTER TABLE Portfolio_SQL..COVID_DEATH_SPL
ALTER COLUMN total_deaths float;

ALTER TABLE Portfolio_SQL..COVID_DEATH_SPL
ALTER COLUMN population int;

ALTER TABLE Portfolio_SQL..COVID_DEATH_SPL
ALTER COLUMN new_cases int;

ALTER TABLE Portfolio_SQL..COVID
ALTER COLUMN new_vaccinations float;





--TOTEL DEATH Percentage 

select date,location,population,total_cases,total_deaths,(total_deaths/NULLIF(total_cases,0)*100) as Death_Percentage
from Portfolio_SQL..COVID_DEATH_SPL 
where location like '%india%'
order by 2 




--PERCENTAGE OF PEOPLE THAT GOT COVID VS POPULATION

select date,location,population,total_cases,(total_cases/NULLIF(population,0)*100) as Infection_Percentage
from Portfolio_SQL..COVID_DEATH_SPL 
order by 1,2;




--COUNTRIS HAVING THE MOST INFECTION RATE 

SELECT location,population,max(total_cases),max(total_cases/NULLIF(population,0)*100) as Infection_Percentage
FROM Portfolio_SQL..COVID_DEATH_SPL 
group by location , population
ORDER by Infection_Percentage desc;
 



 --TOTEL DEATHS REPORTED UNTILL 2023

 SELECT location,MAX(total_deaths) as Deaths
 from Portfolio_SQL..COVID_DEATH_SPL
 GROUP BY location 
 ORDER BY Deaths desc




 --CLEANING THE TOP 9 COLUMN IN THE TABLE FOR ACCURATE RESULTS OR OFFSETTING

 SELECT location,MAX(total_deaths) as Deaths
 FROM Portfolio_SQL..COVID_DEATH_SPL
 GROUP BY location 
 ORDER BY Deaths desc
 OFFSET 9 ROWS





 --TOTEL DEATHS ACCORDING TO CONTINTENT

 SELECT continent , max(total_deaths) as Deaths
 FROM Portfolio_SQL..COVID_DEATH_SPL
 WHERE continent is NOT NULL
 GROUP BY continent
 ORDER BY Deaths desc
 OFFSET 1 ROWS
 




 --THE NUMBER OF CASES ACCORDING TO DATE 

 SELECT date,sum(new_cases) as NO_OF_CASES
 FROM Portfolio_SQL..COVID_DEATH_SPL
 GROUP BY date
 ORDER BY date,NO_OF_CASES ASC;
 




--JOIN THE 2 TABLES

SELECT * 
FROM Portfolio_SQL..COVID_DEATH_SPL dt JOIN Portfolio_SQL..COVID vc
ON  dt.location = vc.location and dt.date = vc.date





/*
LETS FIND OUT HOW MANY PEOPLE GOT VACCINATED THROUGHOUT THE WORLD
WHAT IT WILL DO IS 
IT WILL TAKE ALL THE FIRST ELEMENT OF THE NEW_VACCINATION LIST AND ADD TO THE BOTTEM LIST AND UPDATE THE AUTO UPDATE LIST 
SO BASICALLY WE WILL GET THE SUM OF ALL THE PEOPLE WHO IS VACCINATED THROUGHOUT THE WORLD ACCORDING TO THE GIVEN DATABASE
*/

SELECT  dt.continent , dt.location , dt.date , dt.population , vc.new_vaccinations , 
SUM(vc.new_vaccinations) OVER (PARTITION BY dt.location ORDER BY dt.location,dt.date) as Auto_Upgrade_List
FROM Portfolio_SQL..COVID_DEATH_SPL dt 
JOIN Portfolio_SQL..COVID vc
ON  dt.location = vc.location and dt.date = vc.date
WHERE dt.continent is not null
order by 1,2,3
offset 13947 rows




--USE TEMP TABLE

WITH Population_Vaccination(continent,location,date,population,new_vaccination,Auto_Upgrade_List)
as
(
SELECT  dt.continent , dt.location , dt.date , dt.population , vc.new_vaccinations , 
SUM(vc.new_vaccinations) OVER (PARTITION BY dt.location ORDER BY dt.location,dt.date) as Auto_Upgrade_List
FROM Portfolio_SQL..COVID_DEATH_SPL dt 
JOIN Portfolio_SQL..COVID vc
ON  dt.location = vc.location and dt.date = vc.date
WHERE dt.continent is not null
)
select *,(Auto_Upgrade_List/population)*100 
from Population_Vaccination




-- VIEW CREATION 

CREATE VIEW Population_Vaccination AS 
SELECT  dt.continent , dt.location , dt.date , dt.population , vc.new_vaccinations , 
SUM(vc.new_vaccinations) OVER (PARTITION BY dt.location ORDER BY dt.location,dt.date) as Auto_Upgrade_List
FROM Portfolio_SQL..COVID_DEATH_SPL dt 
JOIN Portfolio_SQL..COVID vc
ON  dt.location = vc.location and dt.date = vc.date
WHERE dt.continent is not null
--ORDER BY 2,3











--