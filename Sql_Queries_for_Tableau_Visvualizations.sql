

--Sql queries for Tableau Project



--1.

select  sum(total_cases)as Total_cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage
from CovidDeaths
where continent is not null
--group by date
order by 1,2


--2.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3.

select location,Population,max(total_cases) as max_total_cases ,cast(max((total_cases/population))*100 as decimal(10,2)) as Percentinfectedpopulation
from CovidDeaths
where continent is not null
group by location,Population
order by Percentinfectedpopulation desc

--4

select location,population,date,max(total_cases) as HighestInfectionCount,max(cast((total_cases/population)*100 as decimal(10,2))) as TotalCasesPercentage
from CovidDeaths
where continent is not null
group by location,population,date
--where location='India'
order by TotalCasesPercentage desc
 