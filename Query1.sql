/* PROJECT BOOTMCAMP 

My notes 

-----------------------------------------------
* SELECT'S * 
--- 1 
use PortfolioProject
select * from CovidDeaths
select * from CovidVaccinations

--2 
select * from CovidDeaths 
order by 3,4 

select * from CovidVaccinations
order by 3,4 

I started this session at 13 min, around 8 pm 

-----------------------------------------------
* Coments * 

-- Cuando no tengo la base de datos selecionda puedo hacerla asi: 
select * from PortfolioProject..CovidDeaths



*/
SELECT * FROM CovidDeaths

-- Select Data that we're gonna use -- ALEX 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths 
ORDER BY 1,2

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Looking at Total Cases VS Total Deats -- ALEX 
-- Shows likelihood of daying if contract covid in your country 
SELECT location, date, total_cases, total_deaths,(total_deaths / total_cases) * 100 AS DeathPorcentaje 
FROM CovidDeaths 
WHERE location like '%states%' 
-- WHERE location IN ('New')
AND continent IS NOT NULL 
ORDER BY 1,2 

-- Locations MINE 
SELECT location 
FROM CovidDeaths 
GROUP BY location 

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Looking tatal cases VS Populations -- ALEX 
-- Show what Porcentaje of population got Covid 

SELECT location, date, population, total_cases,(total_cases / population) * 100 AS A   
FROM CovidDeaths 
WHERE location like '%states%' 
-- WHERE location IN ('New')
ORDER BY 1,2 

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Looking at countries with highest Infection rate compared to Population -- ALEX 

SELECT location, population, MAX(total_cases) AS HighestInfecCount, MAX((total_cases / population)) * 100 AS PercentPopInfected 
FROM CovidDeaths 
--WHERE location like '%states%' 
GROUP BY location, population
ORDER BY PercentPopInfected DESC   

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Showing Countries with highest Death Count Per Population 1 
-- this one gave an error due the DATA TYPE 
SELECT location, MAX(total_deaths) AS TotalDeatsCounts 
FROM CovidDeaths 
--WHERE location like '%states%' 
GROUP BY location 
ORDER BY TotalDeatsCounts DESC   

-- Showing Countries with highest Death Count Per Population 2  
-- This one he added the "CAST"
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeatsCounts 
FROM CovidDeaths 
--WHERE location like '%states%' 
WHERE continent IS NOT NULL 
GROUP BY location 
ORDER BY TotalDeatsCounts DESC   

/* 
-- The error here was not in the query but the data itself 
-- He did this to fix it 

SELECT * FROM CovidDeaths 
WHERE continent IS NOT NULL 
ORDER BY 3,4 

*/ 

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- QUERIES BREAKING INTO ** CONTINENT ** 

-- 1 
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeatsCounts 
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY continent 
ORDER BY TotalDeatsCounts DESC 

-- 2
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeatsCounts 
FROM CovidDeaths 
GROUP BY continent 
ORDER BY TotalDeatsCounts DESC 

--3 -- This are the CORRECT NUMBERS 
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeatsCounts 
FROM CovidDeaths 
WHERE continent IS  NULL 
GROUP BY location 
ORDER BY TotalDeatsCounts DESC 

--4 -- This is the one he kept using 
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeatsCounts 
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY continent 
ORDER BY TotalDeatsCounts DESC 


-- Showing continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeatsCounts 
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY continent 
ORDER BY TotalDeatsCounts DESC 

-- After this query I need to start thinking in how I'm going to use them as a "VIEWPOINT" -- MINE 
-- We want to calculate everything accros the entire world -- MINE 

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- ** GLOBLA NUMBERS ** 

-- 1 -- it didn't work 
SELECT date, total_cases, total_deaths,(total_deaths / total_cases) * 100 AS DeathPorcentaje 
FROM CovidDeaths 
-- WHERE location like '%states%' 
-- WHERE location IN ('New')
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2 

-- 2: He did this 
SELECT date, SUM(new_cases) 
FROM CovidDeaths 
-- WHERE location like '%states%'  
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2  

-- 3: He did this 
SELECT date, SUM(new_cases), SUM(CAST(new_deaths AS INT)), SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage 
FROM CovidDeaths 
-- WHERE location like '%states%'  
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2 

-- 3.1: I did this... this show the daily cases 
SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, ROUND(SUM(CAST(new_deaths AS INT)) / SUM(new_cases), 4) * 100 AS Death_Percentage 
FROM CovidDeaths 
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2 

-- 3.2: I did this... this shows the total 
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, ROUND(SUM(CAST(new_deaths AS INT)) / SUM(new_cases), 4) * 100 AS Death_Percentage 
FROM CovidDeaths  
WHERE continent IS NOT NULL 
ORDER BY 1,2 

--- I ended at 10:19 pm at min 50:09 from the VIDEO on 02-12th --- 
SELECT * FROM CovidDeaths

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* Session 2.... 02-14th 

I started at 10:19 pm at min 50:09 from the VIDEO

SELECT * 
FROM CovidVaccinations

*/

SELECT * FROM CovidVaccinations
-- 3.2: I did this... this shows the total 
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, ROUND(SUM(CAST(new_deaths AS INT)) / SUM(new_cases), 4) * 100 AS Death_Percentage 
FROM CovidDeaths  
WHERE continent IS NOT NULL 
ORDER BY 1,2 

-- He used the other TABLE 
-- Regular JOIN 
SELECT * 
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Looking total population VS Vaccionation 

--1 .. Normal 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%canada%' 
ORDER BY 2,3

--2 This one needs the "CAST"
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location)
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%canada%' 
ORDER BY 2,3

--2.1 Thsi is with "CAST"
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location)
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%canada%' 
ORDER BY 2,3

--2.2 Thsi is with gives me the total amount of the new vaccinations but is not adding by dates. 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location) AS Counts
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%canada%' 
ORDER BY 2,3

--2.3 Thsi is with gives me the total amount of the new vaccinations but is not adding by dates, 
-- but this is is adding the new vaccinations per and we do with this:
-- "OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)"
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
ORDER BY 2,3 

-- 2.4 Once we have this we want to know how many people within the countries are VAC 
-- We use the result of this "SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac"
-- and divided by population 
-- But we can't use this "Rolling_People_Vac"
-- So in order for us to use it like this we have to create a CTE or TEMP Table 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
ORDER BY 2,3 

-- CTE -- ALEX 
-- 1. The numbers of Colums must be the within the CTE and the query 
WITH PopVsVac (Continet, Location, Date, Population, new_vaccinations, Rolling_People_Vac)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
--ORDER BY 2,3 
)
SELECT *, (Rolling_People_Vac / Population ) * 100 AS Total_people_Vac 
FROM PopVsVac  

/* CTE -- MINE 
-- 1. The numbers of Colums must be the within the CTE and the query 
WITH PopVsVac (Continet, Location, Date, Population, new_vaccinations, Rolling_People_Vac) 
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
--ORDER BY 2,3 
)
SELECT *, ROUND((Rolling_People_Vac / Population ) * 100, 2) Total_people_Vac 
FROM PopVsVac
ORDER BY Total_people_Vac DESC  
*/ 

SELECT * FROM CovidDeaths -- JUST TO SEPARETE THE THINGS 
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--- TEMP TABLES 

-- 1 without the "DROP" 
-- If I try to re-run this query without this "DROP TABLE IF EXISTS #PercentPopulationVaccinated" is not gonna allow it me because the table even thought is just TEMP is already there 

CREATE TABLE #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Lcoation nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vac numeric 
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
--ORDER BY 2,3 

SELECT *, (Rolling_People_Vac / Population ) * 100 AS Total_people_Vac 
FROM #PercentPopulationVaccinated 

-- 2 with the "DROP" 
-- Basically what this does is that if I need to reacreate the TEMP TABLE is going to allow me bacause is going to delete the table and create it 

DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Lcoation nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vac numeric 
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
--ORDER BY 2,3 

SELECT *, (Rolling_People_Vac / Population ) * 100 AS Total_people_Vac 
FROM #PercentPopulationVaccinated 



-- //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- CREATING VIEWS TO STORE DATE FOR LATER VISUALIZATIONS 

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT( INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vac
FROM CovidDeaths AS dea 
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date 
WHERE dea.continent IS NOT NULL 
--WHERE dea.location LIKE '%states%' 
--ORDER BY 2,3 

SELECT * FROM PercentPopulationVaccinated 

--HOMEWORK: CREATE VIEWS FROM ALL THE QUERIES ABOVE 








