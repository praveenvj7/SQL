# COVID-19 Data Exploration SQL Project

## Overview

This project contains a comprehensive SQL script for exploring and analyzing COVID-19 data. The script utilizes various advanced SQL techniques to extract meaningful insights from the pandemic data.

## Skills Demonstrated

- Joins
- Common Table Expressions (CTEs)
- Temporary Tables
- Window Functions
- Aggregate Functions
- Views
- Data Type Conversion

## Data Sources

The analysis uses two main datasets:
1. CovidDeaths$: Contains information about COVID-19 cases and deaths.
2. CovidVaccinations$: Contains data related to COVID-19 vaccinations.

## Key Analyses

1. **Total Cases vs Total Deaths**: Calculates the likelihood of dying if contracting COVID-19 in a specific country.
2. **Total Cases vs Population**: Shows the percentage of population infected with COVID-19.
3. **Countries with Highest Infection Rate**: Identifies countries with the highest infection rates relative to their population.
4. **Countries with Highest Death Count**: Lists countries with the highest total death count.
5. **Continent-wise Analysis**: Breaks down death counts by continent.
6. **Global Numbers**: Provides overall global statistics for cases, deaths, and death percentage.
7. **Population vs Vaccinations**: Analyzes the percentage of population that has received at least one COVID-19 vaccine dose.
8. **Vaccination Progress**: Tracks the rolling count of people vaccinated over time.

## Advanced Queries

- Utilizes Common Table Expressions (CTEs) for complex calculations.
- Creates temporary tables for intermediate result storage.
- Implements window functions for running totals and partitioned calculations.

## Visualizations

The script includes the creation of views that can be used for later visualizations:
- PercentPopulationVaccinated: View storing vaccination progress data.

## Additional Analyses

- COVID-19 impact per continent (total cases and deaths).
- Monthly new cases by country.
- Correlation between economic factors (GDP per capita) and COVID-19 mortality rates.
- Time-series analysis of new cases and deaths for specific countries.
- Relationship between healthcare infrastructure and COVID-19 outcomes.
- Vaccination rates and GDP per capita.
- Life expectancy in highly vaccinated countries.
- Vaccination progress in Europe and healthcare infrastructure.
- Time-series progression of cases and vaccinations by country.
- Continental life expectancy during the pandemic.

## How to Use

1. Ensure you have access to a SQL Server environment.
2. Import the COVID-19 datasets (CovidDeaths$ and CovidVaccinations$) into your database.
3. Execute the SQL script in your preferred SQL client.
4. Modify the queries as needed for specific analyses or time periods.

## Future Enhancements

- Incorporate more recent data for ongoing analysis.
- Add more complex statistical analyses.
- Create stored procedures for frequently used queries.
- Develop a dashboard for real-time data visualization.

## Contributing

Contributions to enhance the analysis or add new features are welcome. Please
