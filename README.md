Prediction of clinical outcomes after methotrexate initiation (EHDEN Study-a-thon Barcelona 2020)
=================================================================================================

<img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started">

- Analytics use case(s): **Patient Level Prediction**
- Study type: **Clinical Application**
- Tags: **EHDEN**
- Study lead: **Ross Williams**
- Study lead forums tag: **[rossw](https://forums.ohdsi.org/u/rossw)**
- Study start date: **January 16, 2020**
- Study end date: **-**
- Protocol: [**Word file**](https://github.com/ohdsi-studies/EhdenRaPrediction/blob/master/documents/RA_PLP_protocol_27012020.docx)
- Publications: **-**
- Results explorer: **-**

Prediction of clinical outcomes after methotrexate initiation

**NOTE:** The following information below requires review from the Study Coordinator before using the package.

Introduction
===================

This is a package to train models to predict for
Patients who are:
[EHDEN RA] New users of methoxtrexate monotherapy used for PLP
[EHDEN RA] Female new users of methoxtrexate monotherapy used for PLP (we are predicting breast and uterus cancer and so are limiting for these to female patients)

Who will develop:
[EHDEN RA] Stroke (ischemic or hemorrhagic) events (any visit)
[EHDEN RA] Acute myocardial infarction events (in any visit)
[EHDEN RA] Pancytopenia events using diagnoses and measurements
[EHDEN RA] Opportunistic Infections
[EHDEN RA] Serious Infection  events
[EHDEN RA] Persons with a Malignant neoplasm of breast 1 dx
[EHDEN RA] Persons with a Malignant neoplasm of uterus 1 dx
[EHDEN RA] Persons with a Malignant neoplasm of colon and rectum 1 dx
[EHDEN RA] Serious Infection, opportunistic infections and other infections of interest event
[EHDEN RA] Leukopenia events using diagnoses and measurements
[EHDEN RA] Pancytopenia or leukopenia events using diagnoses and measurements
in 90-days, 2 years and 5 years time at risk.

***To run validation scroll down to "Install Validation Package"*** 

Instructions To Build Package
===================

- Build the package by clicking the R studio 'Install and Restart' button in the built tab 

Instructions To Run Package
===================

- Share the package by adding it to the OHDSI/StudyProtocolSandbox github repo and get people to install by running but replace 'EHDENRAPrediction' with your study name if not using atlas:
```r
  # get the latest PatientLevelPrediction
  install.packages("devtools")
  devtools::install_github("OHDSI/PatientLevelPrediction")
  # check the package
  PatientLevelPrediction::checkPlpInstallation()
  
  # install the network package
  devtools::install_github("https://github.com/ohdsi-studies/EhdenRaPrediction")
```

- To execute the study by running the code in (extras/CodeToRun.R)
```r
  library(EHDENRAPrediction)
  # USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./EHDENRAPredictionResults"

# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "location with space to save big data")

# Details for connecting to the server:
dbms <- "you dbms"
user <- 'your username'
pw <- 'your password'
server <- 'your server'
port <- 'your port'

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- 'cdm database schema'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'EHDENRAPredictionCohort'
#=======================

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        createProtocol = F,
        createCohorts = T,
        runAnalyses = T,
        createResultsDoc = F,
        packageResults = T,
        createValidationPackage = F,
        minCellCount= 5)
```
- You can then easily transport the trained models into a network validation study package by running:
```r
  
  execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createProtocol = F,
        createCohorts = F,
        runAnalyses = F,
        createResultsDoc = F,
        packageResults = F,
        createValidationPackage = T,
        minCellCount= 5)
  

```

- To create the shiny app and view run:
```r
  
populateShinyApp(resultDirectory = outputFolder,
                 minCellCount = 10, 
                 databaseName = 'friendly name'
                 ) 
        
viewShiny('EHDENRAPrediction')
  

```

Install Validation Package
=====================

```r

install.packages("devtools")
library(devtools)
install_github("ohdsi-studies/EhdenRaPrediction/validationPackage/EHDENRAPredictionValidation")

To run the vaidation package:

# If not building locally uncomment and run:

#install.packages("devtools")
#devtools::install_github("OHDSI/StudyProtocolSandbox/EHDENRAPredictionValidation")

library(EHDENRAPredictionValidation)

# add details of your database setting:
databaseName <- 'add a shareable name for the database you are currently validating on'

# add the cdm database schema with the data
cdmDatabaseSchema <- 'your cdm database schema for the validation'

# add the work database schema this requires read/write privileges 
cohortDatabaseSchema <- 'your work database schema'

# if using oracle please set the location of your temp schema
oracleTempSchema <- NULL

# the name of the table that will be created in cohortDatabaseSchema to hold the cohorts
cohortTable <- 'EHDENRAPredictionValidationCohortTable'

# the location to save the prediction models results to:
outputFolder <- getwd()

# add connection details:
options(fftempdir = 'T:/fftemp')
dbms <- "pdw"
user <- NULL
pw <- NULL
server <- Sys.getenv('server')
port <- Sys.getenv('port')
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Now run the study
EHDENRAPredictionValidation::execute(connectionDetails = connectionDetails,
                 databaseName = databaseName,
                 cdmDatabaseSchema = cdmDatabaseSchema,
                 cohortDatabaseSchema = cohortDatabaseSchema,
                 oracleTempSchema = oracleTempSchema,
                 cohortTable = cohortTable,
                 outputFolder = outputFolder,
                 createCohorts = T,
                 runValidation = T,
                 packageResults = T,
                 minCellCount = 5,
                 sampleSize = NULL)
                 

```

Once you have sucessfully executed the study run you will find a compressed folder in the location specified by '[outputFolder]/[databaseName]' named 'resultsToShare.zip'. The study should remove sensitive data but we encourage researchers to also check the contents of this folder (it will contain a rds file with the results which can be loaded via readRDS('[file location]'). Please send the compressed folder results to Cynthia Yang c.yang AT erasmusmc.nl.

# Development status
Under development. Do not use
