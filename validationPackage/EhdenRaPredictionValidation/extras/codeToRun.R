library(EhdenRaPredictionValidation)

#set location for storing temporary files
options(andromedaTempFolder = <set andromeda temp directory>)
# the location to save the prediction models results to:
outputFolder <- './EhdenRaPredictionValidationResults'

# add connection details:
dbms <- "your dbms"
user <- "your username"
pw <- 'your password'
server <- "your server"
port <- "your port"

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# add details of your database setting:
cdmDatabaseName <- cdmDatabaseName

# add the cdm database schema with the data
cdmDatabaseSchema <- databaseSchemas

# add the work database schema this requires read/write privileges
cohortDatabaseSchema <- 'work database schema'

# if using oracle please set the location of your temp schema
oracleTempSchema <- NULL

# the name of the table that will be created in cohortDatabaseSchema to hold the cohorts
cohortTable <- 'EhdenRaPredictionValidationCohortTable'


# Now run the study
EhdenRaPredictionValidation::execute(connectionDetails = connectionDetails,
                                     cdmDatabaseName = cdmDatabaseName,
                                     cdmDatabaseSchema = cdmDatabaseSchema,
                                     cohortDatabaseSchema = cohortDatabaseSchema,
                                     oracleTempSchema = NULL,
                                     cohortTable = cohortTable,
                                     outputFolder = outputFolder,
                                     createCohorts = T,
                                     runValidation = T,
                                     packageResults = F,
                                     minCellCount = 5,
                                     sampleSize = NULL)
# the results will be saved to outputFolder.  If you set this to the
# predictionStudyResults/Validation package then the validation results
# will be accessible to the shiny viewer

# to package the results run (run after the validation results are complete):
# NOTE: the minCellCount = N will remove any result with N patients or less
# EhdenRaPredictionValidation::execute(connectionDetails = connectionDetails,
#                                  databaseName = databaseName,
#                                  cdmDatabaseSchema = cdmDatabaseSchema,
#                                  cohortDatabaseSchema = cohortDatabaseSchema,
#                                  oracleTempSchema = oracleTempSchema,
#                                  cohortTable = cohortTable,
#                                  outputFolder = outputFolder,
#                                  createCohorts = F,
#                                  runValidation = F,
#                                  packageResults = T,
#                                  minCellCount = 5,
#                                  sampleSize = NULL)

