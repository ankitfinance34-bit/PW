use world

-- Question 1 : Count how many cities are there in each country?

select co.Continent, count(ci.CountryCode) as Count_of_Cities
from city as ci join country as co
on ci.CountryCode = co.Code
group by co.Continent

-- Question 2 : Display all continents having more than 30 countries.

select co.Continent
from city as ci join country as co
on ci.CountryCode = co.Code
group by co.Continent
having count(co.Code) > 30


-- Question 3 : List regions whose total population exceeds 200 million.

select Region 
from country
where Population > 200000000


-- Question 4 : Find the top 5 continents by average GNP per country.

select Continent, avg(GNP)
from country 
group by Continent
order by avg(GNP) desc
limit 5


-- Question 5 : Find the total number of official languages spoken in each continent

select co.Continent, count(cl.Language) as Total_of_Language
from country as co join Countrylanguage as cl
on co.Code = cl.CountryCode
group by Co.Continent


-- Question 6 : Find the maximum and minimum GNP for each continent.

select Continent, min(GNP) as Minimum_GNP, max(GNP) as Maximum_GNP
from country 
group by Continent

-- Question 7 : Find the country with the highest average city population.

select co.Name, avg(ci.Population) as Average_City_Population
from city as ci join country as co
on ci.CountryCode = co.Code
group by co.Name
order by avg(ci.Population) desc
limit 1


-- Question 8 : List continents where the average city population is greater than 200,000.

select co.Continent, avg(ci.Population) as Average_City_Population
from city as ci join country as co
on ci.CountryCode = co.Code
group by co.Continent
having avg(ci.Population) > 200000


-- Question 9 : Find the total population and average life expectancy for each continent, ordered by average life
-- expectancy descending.


select Continent, sum(Population) as Total_Population ,avg(LifeExpectancy) as Average_Life_Expectancy
from country 
group by Continent
order by avg(LifeExpectancy) desc


-- Question 10 : Find the top 3 continents with the highest average life expectancy, but only include those where
-- the total population is over 200 million.


select Continent, avg(LifeExpectancy) as Average_Life_Expectancy, sum(Population) as Total_Population
from country
group by Continent
having sum(Population) > 200000000
order by avg(LifeExpectancy) desc
limit 3
