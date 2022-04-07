Select * from PortfolioProjectCovid..CovidDeaths
order by 3,4

--Select * from PortfolioProjectCovid..CovidVaccinations
--order by 3,4

-- Select that we are going to be using

Select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProjectCovid..CovidDeaths
order by 1,2

--Total cases vs Total deaths
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjectCovid..CovidDeaths
order by 1,2

--Total cases vs Total death
-- Shows likelihood of you dying if you contract Covid in your country
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjectCovid..CovidDeaths
where location like '%Aus%'
order by 1,2

-- Looking at Total-cases vs Population
-- Shows what percentage of population got Covid
select location, date,  population, total_cases, (total_cases/population)*100 as CovidInfectionPercentage
from PortfolioProjectCovid..CovidDeaths
--where location like '%Aus%'
order by 1,2


-- Looking at countries with highest infections rate compared to Population
select location,  population, max(total_cases) as TotalInfectionsCount, Max((total_cases/population))*100 as CovidInfectionPercentage
from PortfolioProjectCovid..CovidDeaths
--where location like 'India'
group by location , population

order by CovidInfectionPercentage desc

--Showing continents with highest death count per population
-- Break things down by continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjectCovid..CovidDeaths
where continent is not null 
group by continent
order by TotalDeathCount desc


 --Global Numbers by date
Select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalDeathPercentage
from PortfolioProjectCovid..CovidDeaths
where continent is not null
group by date	
order by 1,2

-- Total Global numbers

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalDeathPercentage
from PortfolioProjectCovid..CovidDeaths
where continent is not null

order by 1,2


-- Looking at total vaccination vs population
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProjectCovid..CovidDeaths dea join
PortfolioProjectCovid..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3

----(RollingPeopleVaccinated/population)*100 use CTE or Temp or view to call this


-- Use CTE

With PopVsVac(continent,location,date,population, new_vaccination,RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProjectCovid..CovidDeaths dea join
PortfolioProjectCovid..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *,(RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated from PopVsVac



-- Using Temp Tables

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated 
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProjectCovid..CovidDeaths dea join
PortfolioProjectCovid..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null

Select *,(RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated from #PercentPopulationVaccinated

 -- Creating View to store date for visualization

Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProjectCovid..CovidDeaths dea join
PortfolioProjectCovid..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null

Select * from PercentPopulationVaccinated


Create View GlobalNumbers as
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjectCovid..CovidDeaths
where continent is not null 
group by continent
--order by TotalDeathCount desc

Select * from GlobalNumbers

Create view CovidInfectionsRate as
select location,  population, max(total_cases) as TotalInfectionsCount, Max((total_cases/population))*100 as CovidInfectionPercentage
from PortfolioProjectCovid..CovidDeaths
--where location like 'India'
group by location , population


Create view TotalNumberofCases as 
select location, date,  population, total_cases, (total_cases/population)*100 as CovidInfectionPercentage
from PortfolioProjectCovid..CovidDeaths

Create view  DeathPercentage as 
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjectCovid..CovidDeaths











