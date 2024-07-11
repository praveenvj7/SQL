/*
Covid 19 Data Exploration 
Skills: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths$
Where continent is not null 
order by Location, date


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
Where location like '%states%'
and continent is not null 
order by Location, date

--What is the total number of COVID-19 cases and deaths per continent?
--Business Question: Understanding the total impact of COVID-19 in terms of cases and deaths per continent can help in resource allocation and identifying regions that need more attention.

SELECT 
    continent, 
    SUM(cast(total_cases as bigint)) AS total_cases, 
    SUM(cast(total_deaths as bigint)) AS total_deaths
FROM 
    CovidDeaths$
GROUP BY 
    continent;

--Which countries had the highest and lowest number of new cases in a given month?
--Business Question: Identifying countries with the highest and lowest new cases can help in understanding the effectiveness
--of different countries' response strategies.

SELECT 
    location, 
    SUM(new_cases) AS total_new_cases
FROM 
    CovidDeaths$
WHERE 
    DATEPART(month, date) = 6 -- Specify the month (e.g., June)
GROUP BY 
    location
ORDER BY 
    total_new_cases DESC;
	
--What is the average life expectancy and GDP per capita of countries with high COVID-19 mortality rates?
--Business Question: This helps to understand if there's a correlation between economic factors and COVID-19 mortality rates.

SELECT 
    location, 
    AVG(life_expectancy) AS avg_life_expectancy, 
    AVG(gdp_per_capita) AS avg_gdp_per_capita
FROM 
    CovidDeaths$
WHERE 
    total_deaths > 1000 -- Define "high mortality" threshold
GROUP BY 
    location;

--How did the number of new cases and deaths change over time for a specific country?
--Business Question: Analyzing trends over time for a specific country can help in understanding the progression of the pandemic 
--and the effectiveness of measures taken.

SELECT 
    date, 
    new_cases, 
    new_deaths
FROM 
    CovidDeaths$
WHERE 
    location = 'India' -- Specify the country
ORDER BY 
    date;

--What is the relationship between healthcare factors (hospital beds per thousand, handwashing facilities) and COVID-19 mortality rates?
--Business Question: This helps to identify if there's a relationship between healthcare infrastructure and COVID-19 outcomes.

SELECT 
    location, 
    AVG(hospital_beds_per_thousand) AS avg_hospital_beds, 
    AVG(handwashing_facilities) AS avg_handwashing_facilities, 
    SUM(cast(total_deaths as bigint)) AS total_deaths
FROM 
    CovidDeaths$
GROUP BY 
    location
ORDER BY 
    total_deaths DESC;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths$
--Where location like '%states%'
order by Location, date


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by total_cases,total_deaths



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by dea.location, dea.date


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


--Which country has the highest total vaccinations, and what is the GDP per capita of that country?
--subquery to find the country with the highest total vaccinations.

SELECT location, gdp_per_capita
FROM CovidVaccinations$
WHERE total_vaccinations = (
    SELECT MAX(total_vaccinations)
    FROM CovidVaccinations$
);

--What is the average life expectancy of countries with a total_vaccinations_per_hundred above 50?
--subquery to filter countries with a total_vaccinations_per_hundred above 50.

-- What is the total number of vaccinations administered in Europe, and what is the average hospital beds per thousand in those countries?
-- Common Table Expression (CTE) to calculate the total number of vaccinations in Europe and
--then we find the average hospital beds per thousand.

SELECT AVG(CAST(life_expectancy AS FLOAT)) AS average_life_expectancy
FROM CovidVaccinations$
WHERE CAST(total_vaccinations_per_hundred AS FLOAT) > 50;

WITH EuropeVaccinations AS (
    SELECT location, 
           SUM(CAST(total_vaccinations AS FLOAT)) AS total_vaccinations, 
           AVG(CAST(hospital_beds_per_thousand AS FLOAT)) AS avg_hospital_beds
    FROM CovidVaccinations$
    WHERE continent = 'Europe'
    GROUP BY location
)
SELECT SUM(total_vaccinations) AS total_vaccinations_in_europe, 
       AVG(avg_hospital_beds) AS avg_hospital_beds_in_europe
FROM EuropeVaccinations;

--How has the total number of COVID-19 cases and total vaccinations progressed over time in each country?

SELECT 
    c.date, 
    c.location, 
    c.total_cases, 
    v.total_vaccinations
FROM 
    CovidDeaths$ c
JOIN 
    CovidVaccinations$ v
ON 
    c.location = v.location AND c.date = v.date
ORDER BY 
    c.location, c.date;

--Which continents have the highest and lowest average life expectancy during the COVID-19 pandemic?

	SELECT 
    c.continent, 
    AVG(c.life_expectancy) AS average_life_expectancy
FROM 
    CovidDeaths$ c
JOIN 
    CovidVaccinations$ d
ON 
    c.continent = d.continent
GROUP BY 
    c.continent
ORDER BY 
    average_life_expectancy DESC;

