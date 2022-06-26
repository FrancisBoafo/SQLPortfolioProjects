
Select location, date, total_cases, new_cases, total_cases, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2 

-- Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%' and  continent is not null
order by 1,2 

-- Total Cases vs Population

Select location, date, total_cases, population, (population/total_cases)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2 

-- Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
Group by location, population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count Per Population
Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by location, population
order by TotalDeathCount desc 

-- Continent with Highest Death Count Per Population
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc 

-- Global Numbers

Select date, SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
SUM(Cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where continent is not null
Group by date 
order by 1,2

-- Global Total Cases
Select  SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
SUM(Cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Total Population vs Vaccinations
Select dea.continent,dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER ( Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeoplevaccinated/population)
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
 order by 2,3

 -- CTE

with PopvsVac (Continent, location, Date, Population, New_Vaccination, RollingPeoplevaccinated)
as 
(
Select dea.continent,dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER ( Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null


)

Select *, (RollingPeoplevaccinated/Population)*100
from PopvsVac


-- TEMP TABLE 

DROP TABLE iF exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER ( Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null


 Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Views for Data Visualization

Create View PercentPopulationVaccinated as
Select dea.continent,dea.location, dea.date , dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER ( Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null

Create View PercentPopulationDeaths as
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent





