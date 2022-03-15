library(tidyverse)

stations <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-01/stations.csv",
  col_types = cols(
    .default = col_character(),
    X = col_double(),
    Y = col_double(),
    OBJECTID = col_double(),
    PLUS4 = col_integer(),
    EV_LEVEL1_EVSE_NUM = col_double(),
    EV_LEVEL2_EVSE_NUM = col_double(),
    EV_DC_FAST_COUNT = col_double(),
    LATITUDE = col_double(),
    LONGITUDE = col_double(),
    ID = col_double(),
    FEDERAL_AGENCY_ID = col_double(),
    LPG_PRIMARY = col_logical(),
    E85_BLENDER_PUMP = col_logical(),
    HYDROGEN_IS_RETAIL = col_logical(),
    CNG_DISPENSER_NUM = col_integer(),
    CNG_TOTAL_COMPRESSION_CAPACITY = col_double(),
    CNG_STORAGE_CAPACITY = col_double(),
    RESTRICTED_ACCESS = col_logical(),
    LATDD = col_double(),
    LONGDD = col_double()
  )
)

saveRDS(stations, "2022-03-01_alternative-fuel-stations/alternative-fuel-stations.rds")

# get SHP file
download.file(
  url = "https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-03-01/Alternative_Fueling_Stations.zip",
  destfile = "2022-03-01_alternative-fuel-stations/Alternative_Fueling_Stations.zip"
)

