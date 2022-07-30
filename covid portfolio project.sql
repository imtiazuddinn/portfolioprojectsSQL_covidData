use portfolioproject

select * from dbo.coviddeaths order by 3, 4 

select * from dbo.covidvaccinations  

--running a simple sql select query
select location,date,total_cases,new_cases,total_deaths,population
from portfolioproject..coviddeaths
order by 1,2


--- Total cases vs Total deaths 
--shows likelihood of dying, if you contract covid in your country 
select location,date,total_cases,new_cases,population,total_deaths,(total_deaths/total_cases)*100 as percentageDeaths
from portfolioproject..coviddeaths where location like 'united kingdom'

-- Looking at total cases vs population 
select location,date,total_cases,new_cases,population,total_deaths,(total_cases/population)*100 as percentageinfection
from portfolioproject..coviddeaths where location like 'united kingdom' order by 1,2


--looking at the countries with highest infection ration compared to populaiton 
select Location,Population,MAX(total_cases) as Highestinfectioncount ,MAX((total_cases/population)*100) as 
percenPopulationInfected
from portfolioproject..coviddeaths
Group by population, location order by percenPopulationInfected desc

--looking at countries with highest deathcount per population.
select Location,MAX(cast(total_deaths as int)) as totaldeathcount ,MAX((total_deaths/population)*100) as 
percenPopulationDied
from portfolioproject..coviddeaths
where continent is not null
Group by  location order by totaldeathcount  desc

--LEts break things down by continent 
select continent,MAX(cast(total_deaths as int)) as totaldeathcount ,MAX((total_deaths/population)*100) as 
percenPopulationDied
from portfolioproject..coviddeaths
where continent is not null 
Group by  continent order by totaldeathcount  desc

--showing the continents with the highest death count 
select continent, MAX((cast(total_deaths as int)/population)*100)) as deathcountpercentage
from portfolioproject..coviddeaths where continent is not null 
group by continent order by deathcountpercentage

---GLobal numbers

select  SUM(new_cases) as totalcases,SUM(cast(new_deaths as int)) as totaldeaths,(SUM(cast(new_deaths as int))/SUM(new_cases)*100) as deathpercentage 
from portfolioproject..coviddeaths
where continent is not null 
--group by date 
order by 2 desc


--using joins to join two tables namely coviddeaths and covidvaccinations
select 
a.location,
a.continent,
a.date,
a.population,
b.new_vaccinations
from portfolioproject..coviddeaths as  a 
join portfolioproject..covidvaccinations as b
on a.location=b.location and a.date=b.date
where a.continent is not null
order by 1,2,3



--using window funciton to calciulate total vaccinations rolled per country

with Tot_vac_per_country as (select 
a.continent,
a.location,
a.date,
a.population,
b.new_vaccinations,
sum(cast(b.new_vaccinations as bigint)) over(partition by a.location order by a.location,a.date) as total_vaccinations_rolled
from portfolioproject..coviddeaths a
join portfolioproject..covidvaccinations b
on a.location=b.location and 
a.date=b.date
where a.continent is not null )
--order by 1,2)
select * from Tot_vac_per_country
 

--creating a view to visualize in Tableau

create view percentPopulationVacinated
as select 
a.continent,
a.location,
a.date,
a.population,
b.new_vaccinations,
sum(cast(b.new_vaccinations as bigint)) over(partition by a.location order by a.location,a.date) as total_vaccinations_rolled
from portfolioproject..coviddeaths a
join portfolioproject..covidvaccinations b
on a.location=b.location and 
a.date=b.date
where a.continent is not null

select * from percentPopulationVacinated


`




 












