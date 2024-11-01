-- First Query: Percentage Change of Vaccinations between Three Dates
WITH cte AS (
    SELECT
        date1.date AS [Date 1 (OD1)],
        date1.location AS [Country Name (CN)],
        date1.total_vaccinations AS [Vaccine on OD1 (VOD1)],
        date2.date AS [Date 2 (OD2)],
        date2.total_vaccinations AS [Vaccine on OD2 (VOD2)],
        date3.date AS [Date 3 (OD3)],
        date3.total_vaccinations AS [Vaccine on OD3 (VOD3)],
        (
            -- Calculate the percentage change in total vaccinations from date1 to date2,
            -- then subtract the percentage change from date2 to date3
            (((CAST(date2.total_vaccinations AS INTEGER) - CAST(date1.total_vaccinations AS INTEGER)) * 100.0 /
            NULLIF(CAST(date1.total_vaccinations AS INTEGER), 0)) -
            ((CAST(date3.total_vaccinations AS INTEGER) - CAST(date2.total_vaccinations AS INTEGER)) * 100.0 /
            NULLIF(CAST(date2.total_vaccinations AS INTEGER), 0)))
        ) AS [Percentage Change of totals]
    FROM
        Vaccinations AS date1
    JOIN
        Vaccinations AS date2 ON date2.date = '2021-05-26' AND date2.location = date1.location
    JOIN
        Vaccinations AS date3 ON date3.date = '2021-05-27' AND date3.location = date1.location
    WHERE
        date1.date = '2021-05-25'
    GROUP BY
        date1.location
)
-- Select all columns from CTE and order by percentage change in descending order
SELECT * FROM cte ORDER BY [Percentage Change of totals] DESC;

-- Second Query: Monthly Growth Rate of Vaccinations
WITH MonthlyTotals AS (
    SELECT
        location AS Country,
        strftime('%m', date) AS Month,
        strftime('%Y', date) AS Year,
        -- Calculate cumulative doses by country per month
        SUM(CAST(total_vaccinations AS INTEGER)) AS CumulativeDoses
    FROM
        Vaccinations
    GROUP BY
        location, Month, Year
),
MonthlyGrowth AS (
    SELECT
        Country,
        Month,
        Year,
        CumulativeDoses,
        -- Calculate the previous month's doses for each country
        LAG(CumulativeDoses) OVER (PARTITION BY Country ORDER BY Year, Month) AS PreviousMonthDoses,
        -- Calculate the growth rate compared to the previous month
        CASE
            WHEN LAG(CumulativeDoses) OVER (PARTITION BY Country ORDER BY Year, Month) IS NOT NULL
            THEN (CumulativeDoses * 1.0 / LAG(CumulativeDoses) OVER (PARTITION BY Country ORDER BY Year, Month))
            ELSE NULL
        END AS GrowthRate
    FROM
        MonthlyTotals
),
GlobalAverage AS (
    SELECT
        AVG(GrowthRate) AS AvgGrowthRate
    FROM
        MonthlyGrowth
    WHERE
        GrowthRate IS NOT NULL
)
-- Select countries with growth rates above the global average
SELECT
    mg.Country,
    mg.Month,
    mg.Year,
    mg.GrowthRate AS GrowthRateOfVaccine,
    (mg.GrowthRate - ga.AvgGrowthRate) AS DifferenceFromGlobalAverage
FROM
    MonthlyGrowth mg
JOIN
    GlobalAverage ga ON mg.GrowthRate IS NOT NULL
WHERE
    mg.GrowthRate > ga.AvgGrowthRate
ORDER BY
    mg.Country, mg.Year, mg.Month;

-- Third Query: Percentage of Vaccine Types Used by Country
WITH RankedVaccines AS (
    SELECT
        vaccine,
        location,
        SUM(total_vaccinations) AS total_vaccinations,
        -- Rank vaccines by total vaccinations per country
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY SUM(total_vaccinations) DESC) AS rank
    FROM
        VaccinationData_All_country_Dim
    GROUP BY
        location, vaccine
), CountryTotals AS (
    SELECT
        location,
        SUM(total_vaccinations) AS total_vaccinations_overall
    FROM
        VaccinationData_All_country_Dim
    GROUP BY
        location
)
-- Calculate the percentage contribution of the top 5 vaccines by total vaccinations
SELECT
    rv.vaccine,
    rv.location,
    ROUND(
        CASE
            WHEN ct.total_vaccinations_overall > 0 THEN
                CAST(rv.total_vaccinations AS DECIMAL(20, 10)) * 1.0 / CAST(ct.total_vaccinations_overall AS DECIMAL(20, 10))
            ELSE
                0
        END * 100, 2) AS [Percentage of vaccine type]
FROM
    RankedVaccines rv
JOIN
    CountryTotals ct ON rv.location = ct.location
WHERE
    rv.rank <= 5
ORDER BY
    rv.location, rv.total_vaccinations DESC;

-- Fourth Query: Total Administered Vaccines Grouped by Month
SELECT
    location AS CountryName,
    strftime('%Y-%m', date) AS Month,
    source_url AS SourceName,
    SUM(total_vaccinations) AS TotalAdministeredVaccines
FROM
    VaccinationData_All_country_Dim
GROUP BY
    location,
    strftime('%Y-%m', date),
    source_url
ORDER BY
    strftime('%Y-%m', date) DESC;

-- Fifth Query: Daily Increments of Fully Vaccinated Individuals
WITH DailyVaccinations AS (
    SELECT
        location,
        date,
        SUM(people_fully_vaccinated) AS total_fully_vaccinated
    FROM
        VaccinationData_All_country_Dim
    WHERE
        location IN ('United States', 'India', 'Ireland', 'China')
        AND date >= '2022-01-01'
        AND date < '2024-01-01'
    GROUP BY
        location, date
),
DailyIncrements AS (
    SELECT
        dv1.date,
        dv1.location,
        -- Calculate daily increments by subtracting the previous day's total fully vaccinated
        dv1.total_fully_vaccinated - COALESCE(dv2.total_fully_vaccinated, 0) AS increment
    FROM
        DailyVaccinations dv1
    LEFT JOIN
        DailyVaccinations dv2
    ON
        dv1.location = dv2.location
        AND dv1.date = DATE(dv2.date, '+1 day')
)
-- Summarize daily increments for specified countries
SELECT
    date,
    SUM(CASE WHEN location = 'United States' THEN increment ELSE 0 END) AS UnitedStates,
    SUM(CASE WHEN location = 'India' THEN increment ELSE 0 END) AS India,
    SUM(CASE WHEN location = 'Ireland' THEN increment ELSE 0 END) AS Ireland,
    SUM(CASE WHEN location = 'China' THEN increment ELSE 0 END) AS China
FROM
    DailyIncrements
GROUP BY
    date
ORDER BY
    date;

-- Sixth Query: Top Countries for Fully Vaccinated Individuals by Vaccine Type
WITH DailyVaccinations AS (
    SELECT
        location,
        date,
        vaccine,
        SUM(people_fully_vaccinated) AS total_fully_vaccinated
    FROM
        VaccinationData_All_country_Dim
    WHERE
        date >= '2022-01-01'
        AND date < '2024-01-01'
    GROUP BY
        location, date, vaccine
),
RankedCountries AS (
    SELECT
        date,
        vaccine,
        location,
        total_fully_vaccinated,
        -- Rank countries based on fully vaccinated individuals per date and vaccine
        ROW_NUMBER() OVER (PARTITION BY date, vaccine ORDER BY total_fully_vaccinated DESC) AS rank
    FROM
        DailyVaccinations
)
-- Select the top 3 countries for fully vaccinated individuals by date and vaccine
SELECT
    date,
    vaccine,
    MAX(CASE WHEN rank = 1 THEN total_fully_vaccinated END) AS FullyVaccinatedTop1,
    MAX(CASE WHEN rank = 2 THEN total_fully_vaccinated END) AS FullyVaccinatedTop2,
    MAX(CASE WHEN rank = 3 THEN total_fully_vaccinated END) AS FullyVaccinatedTop3
FROM
    RankedCountries
GROUP BY
    date, vaccine
ORDER BY
    date, vaccine;
