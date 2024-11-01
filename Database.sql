--
-- File generated with SQLiteStudio v3.4.4 on Fri Nov 1 21:43:40 2024
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Age_Group_Vaccination_Fact
DROP TABLE IF EXISTS Age_Group_Vaccination_Fact;

CREATE TABLE IF NOT EXISTS Age_Group_Vaccination_Fact (
    id                                  INTEGER  PRIMARY KEY,
    age_group_id                        INTEGER  NOT NULL,
    location_id                         INTEGER  NOT NULL,
    date                                DATE     NOT NULL,
    people_vaccinated_per_hundred       REAL,
    people_fully_vaccinated_per_hundred REAL,
    people_with_booster_per_hundred     REAL,
    created_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        age_group_id
    )
    REFERENCES AgeGroup_Dimension (id),
    FOREIGN KEY (
        location_id
    )
    REFERENCES Location_Dimension (id) 
);


-- Table: AgeGroup_Dimension
DROP TABLE IF EXISTS AgeGroup_Dimension;

CREATE TABLE IF NOT EXISTS AgeGroup_Dimension (
    id             INTEGER  PRIMARY KEY,
    age_group      TEXT     NOT NULL,
    created_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    effective_date DATETIME,
    expiry_date    DATETIME,
    current_flag   CHAR (1) DEFAULT 'Y'
);


-- Table: AgeGroupVaccination
DROP TABLE IF EXISTS AgeGroupVaccination;

CREATE TABLE IF NOT EXISTS AgeGroupVaccination (
    location                            TEXT NOT NULL,
    date                                TEXT NOT NULL,
    age_group                           TEXT NOT NULL,
    people_vaccinated_per_hundred       TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    people_with_booster_per_hundred     TEXT
);


-- Table: AgeGroupVaccination_Dim
DROP TABLE IF EXISTS AgeGroupVaccination_Dim;

CREATE TABLE IF NOT EXISTS AgeGroupVaccination_Dim (
    id                                  INTEGER  PRIMARY KEY,
    location                            TEXT     NOT NULL,
    date                                TEXT     NOT NULL,
    age_group                           TEXT     NOT NULL,
    people_vaccinated_per_hundred       REAL,
    people_fully_vaccinated_per_hundred REAL,
    people_with_booster_per_hundred     REAL,
    created_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                        DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: CombinedVaccinationData
DROP TABLE IF EXISTS CombinedVaccinationData;

CREATE TABLE IF NOT EXISTS CombinedVaccinationData (
    location                TEXT    NOT NULL,
    date                    TEXT    NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER
);


-- Table: Daily_Vaccination_Fact
DROP TABLE IF EXISTS Daily_Vaccination_Fact;

CREATE TABLE IF NOT EXISTS Daily_Vaccination_Fact (
    id                             INTEGER  PRIMARY KEY,
    location_id                    INTEGER  NOT NULL,
    date                           DATE     NOT NULL,
    daily_vaccinations             INTEGER,
    daily_people_vaccinated        INTEGER,
    daily_vaccinations_per_million REAL,
    created_date                   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        location_id
    )
    REFERENCES Location_Dimension (id) 
);


-- Table: Location_Dimension
DROP TABLE IF EXISTS Location_Dimension;

CREATE TABLE IF NOT EXISTS Location_Dimension (
    id                    INTEGER  PRIMARY KEY,
    location              TEXT     NOT NULL,
    iso_code              TEXT     NOT NULL,
    vaccines              TEXT,
    last_observation_date DATE     NOT NULL,
    source_name           TEXT     NOT NULL,
    source_website        TEXT     NOT NULL,
    created_date          DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date          DATETIME DEFAULT CURRENT_TIMESTAMP,
    effective_date        DATETIME,
    expiry_date           DATETIME,
    current_flag          CHAR (1) DEFAULT 'Y'
);


-- Table: Locations
DROP TABLE IF EXISTS Locations;

CREATE TABLE IF NOT EXISTS Locations (
    location              TEXT NOT NULL,
    iso_code              TEXT NOT NULL,
    vaccines              TEXT,
    last_observation_date TEXT NOT NULL,
    source_name           TEXT NOT NULL,
    source_website        TEXT NOT NULL
);


-- Table: Total_Vaccination_Fact
DROP TABLE IF EXISTS Total_Vaccination_Fact;

CREATE TABLE IF NOT EXISTS Total_Vaccination_Fact (
    id                             INTEGER  PRIMARY KEY,
    location_id                    INTEGER  NOT NULL,
    date                           DATE     NOT NULL,
    total_vaccinations             INTEGER,
    people_vaccinated              INTEGER,
    people_fully_vaccinated        INTEGER,
    total_boosters                 INTEGER,
    total_vaccinations_per_hundred REAL,
    created_date                   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        location_id
    )
    REFERENCES Location_Dimension (id) 
);


-- Table: Vaccination_By_Manufacture
DROP TABLE IF EXISTS Vaccination_By_Manufacture;

CREATE TABLE IF NOT EXISTS Vaccination_By_Manufacture (
    location           TEXT    NOT NULL,
    date               TEXT    NOT NULL,
    vaccine            TEXT    NOT NULL,
    total_vaccinations INTEGER
);


-- Table: Vaccination_By_Manufacturer_Dim
DROP TABLE IF EXISTS Vaccination_By_Manufacturer_Dim;

CREATE TABLE IF NOT EXISTS Vaccination_By_Manufacturer_Dim (
    id                 INTEGER  PRIMARY KEY,
    location           TEXT     NOT NULL,
    date               TEXT     NOT NULL,
    vaccine            TEXT     NOT NULL,
    total_vaccinations INTEGER,
    created_date       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date       DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: Vaccination_Fact
DROP TABLE IF EXISTS Vaccination_Fact;

CREATE TABLE IF NOT EXISTS Vaccination_Fact (
    id                                  INTEGER  PRIMARY KEY,
    location_id                         INTEGER  NOT NULL,
    vaccine_id                          INTEGER  NOT NULL,
    age_group_id                        INTEGER,
    date                                DATE     NOT NULL,
    total_vaccinations                  REAL,
    people_vaccinated                   REAL,
    people_fully_vaccinated             REAL,
    total_boosters                      REAL,
    daily_vaccinations_raw              REAL,
    daily_vaccinations                  REAL,
    total_vaccinations_per_hundred      REAL,
    people_vaccinated_per_hundred       REAL,
    people_fully_vaccinated_per_hundred REAL,
    total_boosters_per_hundred          REAL,
    daily_vaccinations_per_million      REAL,
    daily_people_vaccinated             REAL,
    daily_people_vaccinated_per_hundred REAL,
    created_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        location_id
    )
    REFERENCES Location_Dimension (id),
    FOREIGN KEY (
        vaccine_id
    )
    REFERENCES Vaccinations_Dim (id),
    FOREIGN KEY (
        age_group_id
    )
    REFERENCES AgeGroup_Dimension (id) 
);


-- Table: Vaccination_Summary_Fact
DROP TABLE IF EXISTS Vaccination_Summary_Fact;

CREATE TABLE IF NOT EXISTS Vaccination_Summary_Fact (
    id                            INTEGER  PRIMARY KEY,
    location_id                   INTEGER  NOT NULL,
    date                          DATE     NOT NULL,
    total_vaccinations            INTEGER,
    total_people_vaccinated       INTEGER,
    total_people_fully_vaccinated INTEGER,
    total_boosters                INTEGER,
    created_date                  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        location_id
    )
    REFERENCES Location_Dimension (id) 
);


-- Table: VaccinationData_All_country_Dim
DROP TABLE IF EXISTS VaccinationData_All_country_Dim;

CREATE TABLE IF NOT EXISTS VaccinationData_All_country_Dim (
    id                       INTEGER  PRIMARY KEY AUTOINCREMENT,
    Recored_id_country_level INTEGER,
    location                 TEXT     NOT NULL,
    date                     TEXT     NOT NULL,
    vaccine                  TEXT,
    source_url               TEXT,
    total_vaccinations       INTEGER,
    people_vaccinated        INTEGER,
    people_fully_vaccinated  INTEGER,
    total_boosters           INTEGER,
    created_date             DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date             DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: VaccinationData_Chain
DROP TABLE IF EXISTS VaccinationData_Chain;

CREATE TABLE IF NOT EXISTS VaccinationData_Chain (
    location                TEXT NOT NULL,
    date                    TEXT NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      TEXT,
    people_vaccinated       TEXT,
    people_fully_vaccinated TEXT,
    total_boosters          TEXT
);


-- Table: VaccinationData_Chain_Dim
DROP TABLE IF EXISTS VaccinationData_Chain_Dim;

CREATE TABLE IF NOT EXISTS VaccinationData_Chain_Dim (
    id                      INTEGER  PRIMARY KEY AUTOINCREMENT,
    location                TEXT     NOT NULL,
    date                    TEXT     NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER,
    created_date            DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date            DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: VaccinationData_India
DROP TABLE IF EXISTS VaccinationData_India;

CREATE TABLE IF NOT EXISTS VaccinationData_India (
    location                TEXT NOT NULL,
    date                    TEXT NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      TEXT,
    people_vaccinated       TEXT,
    people_fully_vaccinated TEXT,
    total_boosters          TEXT
);


-- Table: VaccinationData_India_Dim
DROP TABLE IF EXISTS VaccinationData_India_Dim;

CREATE TABLE IF NOT EXISTS VaccinationData_India_Dim (
    id                      INTEGER  PRIMARY KEY AUTOINCREMENT,
    location                TEXT     NOT NULL,
    date                    TEXT     NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER,
    created_date            DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date            DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: VaccinationData_Ireland
DROP TABLE IF EXISTS VaccinationData_Ireland;

CREATE TABLE IF NOT EXISTS VaccinationData_Ireland (
    location                TEXT NOT NULL,
    date                    TEXT NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      TEXT,
    people_vaccinated       TEXT,
    people_fully_vaccinated TEXT,
    total_boosters          TEXT
);


-- Table: VaccinationData_Ireland_Dim
DROP TABLE IF EXISTS VaccinationData_Ireland_Dim;

CREATE TABLE IF NOT EXISTS VaccinationData_Ireland_Dim (
    id                      INTEGER  PRIMARY KEY AUTOINCREMENT,
    location                TEXT     NOT NULL,
    date                    TEXT     NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER,
    created_date            DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date            DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: VaccinationData_United_States
DROP TABLE IF EXISTS VaccinationData_United_States;

CREATE TABLE IF NOT EXISTS VaccinationData_United_States (
    location                TEXT NOT NULL,
    date                    TEXT NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      TEXT,
    people_vaccinated       TEXT,
    people_fully_vaccinated TEXT,
    total_boosters          TEXT
);


-- Table: VaccinationData_United_States_Dim
DROP TABLE IF EXISTS VaccinationData_United_States_Dim;

CREATE TABLE IF NOT EXISTS VaccinationData_United_States_Dim (
    id                      INTEGER  PRIMARY KEY AUTOINCREMENT,
    location                TEXT     NOT NULL,
    date                    TEXT     NOT NULL,
    vaccine                 TEXT,
    source_url              TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER,
    created_date            DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date            DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: Vaccinations
DROP TABLE IF EXISTS Vaccinations;

CREATE TABLE IF NOT EXISTS Vaccinations (
    location                            TEXT NOT NULL,
    iso_code                            TEXT NOT NULL,
    date                                TEXT NOT NULL,
    total_vaccinations                  TEXT,
    people_vaccinated                   TEXT,
    people_fully_vaccinated             TEXT,
    total_boosters                      TEXT,
    daily_vaccinations_raw              TEXT,
    daily_vaccinations                  TEXT,
    total_vaccinations_per_hundred      TEXT,
    people_vaccinated_per_hundred       TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    total_boosters_per_hundred          TEXT,
    daily_vaccinations_per_million      TEXT,
    daily_people_vaccinated             TEXT,
    daily_people_vaccinated_per_hundred TEXT
);


-- Table: Vaccinations_Dim
DROP TABLE IF EXISTS Vaccinations_Dim;

CREATE TABLE IF NOT EXISTS Vaccinations_Dim (
    id                                  INTEGER  PRIMARY KEY,
    location                            TEXT     NOT NULL,
    iso_code                            TEXT     NOT NULL,
    date                                TEXT     NOT NULL,
    total_vaccinations                  REAL,
    people_vaccinated                   REAL,
    people_fully_vaccinated             REAL,
    total_boosters                      REAL,
    daily_vaccinations_raw              REAL,
    daily_vaccinations                  REAL,
    total_vaccinations_per_hundred      REAL,
    people_vaccinated_per_hundred       REAL,
    people_fully_vaccinated_per_hundred REAL,
    total_boosters_per_hundred          REAL,
    daily_vaccinations_per_million      REAL,
    daily_people_vaccinated             REAL,
    daily_people_vaccinated_per_hundred REAL,
    created_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                        DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: VaccinationStatistics_US_State
DROP TABLE IF EXISTS VaccinationStatistics_US_State;

CREATE TABLE IF NOT EXISTS VaccinationStatistics_US_State (
    date                                TEXT NOT NULL,
    location                            TEXT NOT NULL,
    total_vaccinations                  TEXT,
    total_distributed                   TEXT,
    people_vaccinated                   TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    total_vaccinations_per_hundred      TEXT,
    people_fully_vaccinated             TEXT,
    people_vaccinated_per_hundred       TEXT,
    distributed_per_hundred             TEXT,
    daily_vaccinations_raw              TEXT,
    daily_vaccinations                  TEXT,
    daily_vaccinations_per_million      TEXT,
    share_doses_used                    TEXT,
    total_boosters                      TEXT,
    total_boosters_per_hundred          TEXT
);


-- Table: VaccinationStatistics_US_State_Dim
DROP TABLE IF EXISTS VaccinationStatistics_US_State_Dim;

CREATE TABLE IF NOT EXISTS VaccinationStatistics_US_State_Dim (
    id                                  INTEGER  PRIMARY KEY,
    date                                TEXT     NOT NULL,
    location                            TEXT     NOT NULL,
    total_vaccinations                  TEXT,
    total_distributed                   TEXT,
    people_vaccinated                   TEXT,
    people_fully_vaccinated_per_hundred TEXT,
    total_vaccinations_per_hundred      TEXT,
    people_fully_vaccinated             TEXT,
    people_vaccinated_per_hundred       TEXT,
    distributed_per_hundred             TEXT,
    daily_vaccinations_raw              TEXT,
    daily_vaccinations                  TEXT,
    daily_vaccinations_per_million      TEXT,
    share_doses_used                    TEXT,
    total_boosters                      TEXT,
    total_boosters_per_hundred          TEXT,
    created_date                        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date                        DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Table: Vaccine_Manufacturer_Fact
DROP TABLE IF EXISTS Vaccine_Manufacturer_Fact;

CREATE TABLE IF NOT EXISTS Vaccine_Manufacturer_Fact (
    id                 INTEGER  PRIMARY KEY,
    vaccine_id         INTEGER  NOT NULL,
    location_id        INTEGER  NOT NULL,
    date               TEXT     NOT NULL,
    total_vaccinations INTEGER,
    daily_vaccinations INTEGER,
    created_date       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        vaccine_id
    )
    REFERENCES Vaccinations_Dim (id),
    FOREIGN KEY (
        location_id
    )
    REFERENCES Location_Dimension (id) 
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
