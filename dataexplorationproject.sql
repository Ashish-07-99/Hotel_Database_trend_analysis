--create database portfolioprojects

--use portfolioprojects

--select * from CovidDeaths

--select * from CovidVaccinations

--This are the data we wil be most focused on 

select location,date,population,total_cases,new_cases,total_deaths
from CovidDeaths
order by location,date

--Total Cases Vs Total Deaths --Death percentage
--Shows the percentage of chances of death if someone is covid positive

select location,date,total_cases,total_deaths,cast((total_deaths/total_cases)*100 as decimal(10,2)) as deathpercentage
from CovidDeaths
where continent is not null
--where location='India'
order by location,date

--Total cases Vs Population
--shows the percentage of population that got covid positive

select location,date,population,total_cases,cast((total_cases/population)*100 as decimal(10,2)) as TotalCasesPercentage
from CovidDeaths
where continent is not null
--where location='India'
order by location,date


--To show the countries with the highiest infection rate compared to population

select location,Population,max(total_cases) as max_total_cases ,cast(max((total_cases/population))*100 as decimal(10,2)) as Percentinfectedpopulation
from CovidDeaths
where continent is not null
group by location,Population
order by Percentinfectedpopulation desc

--Showing the countries with highest death count per Population

select location,Population,max(cast(total_deaths as int)) as max_total_deaths 
from CovidDeaths
where continent is not null
group by location,Population
order by max_total_deaths desc

--Showing  Continents with highest death count

select location,max(cast(total_deaths as int)) as max_total_deaths 
from CovidDeaths
where continent is null
group by location
order by max_total_deaths desc

--Global Numbers by date 

select date, sum(total_cases)as new_case_bydate, sum(cast(new_deaths as int)) as new_deaths_bydate, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage_bydate
from CovidDeaths
where continent is not null
group by date
order by date

-- Total cases over the vs total deaths and percentage of deaths

select sum(total_cases)as new_case_bydate, sum(cast(new_deaths as int)) as new_deaths_bydate, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage_bydate
from CovidDeaths
where continent is not null
--where location='India'
--group by date
order by 1,2

---------------------------------------
--Looking at the total Population Vs Vaccination

--select * from CovidDeaths cd
-- inner join CovidVaccinations cv on cd.location=cv.location
-- and cd.date=cv.date

select cd.location, sum(cd.population) as total_population,sum(cv.total_vaccinations) as total_vacc from CovidDeaths cd
inner join CovidVaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cv.continent is not null
group by cd.location
order by 1,2

--Achieve the same using a window function 
select cd.location,cd.population,cd.date,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as total_vacc from CovidDeaths cd
inner join CovidVaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cv.continent is not null
order by 1,3

---Total Population Vs Total Vaccination Percentage
with Popvsvac (location,population,date,new_vaccinations,total_vacc)
as (
select cd.location,cd.population,cd.date,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as total_vacc from CovidDeaths cd
inner join CovidVaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cv.continent is not null
)
select *,(total_vacc/population)*100 as Vaccinated_percentage 
from Popvsvac


---Temp Table Method

drop table if exists #PopulationvsVaccination
Create Table #PopulationvsVaccination
(location nvarchar(255),
population numeric,
date nvarchar(255),
new_vaccination numeric,
total_vacc numeric)

insert into #PopulationvsVaccination
select cd.location,cd.population,cd.date,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as total_vacc from CovidDeaths cd
inner join CovidVaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cv.continent is not null

select *,(total_vacc/population)*100 as Vaccinated_percentage  from #PopulationvsVaccination
order by location

---Creating view for visvuallization

create view percent_pop_vaccination as
select cd.location,cd.population,cd.date,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location,cd.date) as total_vacc from CovidDeaths cd
inner join CovidVaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cv.continent is not null

select * from  percent_pop_vaccination