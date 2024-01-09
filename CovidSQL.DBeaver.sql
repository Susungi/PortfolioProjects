

select * 
from deaths d 
where continent is not null 
order by 3,4

-- Looking at total Cases vs Total death
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentPopulationInfeted
from deaths d 
where location like '%states%'
order by 1,2 

-- Looking at totoal Cases Vs population 


select location, population, MAX(total_cases) as highestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from deaths d 
-- where location like '%states%'
group by location, population
order by PercentPopulationInfected desc;

-- Showing the countries with the highest death counts per population

Select location, MAX(total_deaths) as TotalDeathCount
from deaths d 
where continent is not null 
Group by location 
order by TotalDeathCount desc;

 -- Breaking things down by continent 

Select continent, MAX(total_deaths) as TotalDeathCount
from deaths d 
where continent is not null
Group by continent 
order by TotalDeathCount desc;


-- Global Numbers
select date, sum(new_cases) as total_cases , sum(new_deaths) as total_deaths , sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from deaths 
where continent is not null 
group by `date` 
order by 1,2

-- Total Global number
select sum(new_cases) as total_cases , sum(new_deaths) as total_deaths , sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from deaths 
where continent is not null  
order by 1,2


-- Looking at total Population Vs Vaccinations 
select d.continent, d.location, d.date, d.population, v.new_vaccinations 
from vaccins v 
join deaths d 
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 1,2,3

-- Looking at the daily Vaccinations

select d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from vaccins v 
join deaths d 
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 1,2,3

-- use CTE 

with PopvsVac (continent, location, Date, Population, New_Vaccinations,  RollingPeopleVaccinated)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from vaccins v 
join deaths d 
on d.location = v.location and d.date = v.date
where d.continent is not null
-- order by 2,3
)
 
select * 
from PopvsVac





-- TEMP TABLE 
drop table if exist #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations, Sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from vaccins v 
join deaths d 
on d.location = v.location and d.date = v.date
where d.continent is not null
-- order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated











