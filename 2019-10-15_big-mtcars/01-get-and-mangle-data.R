library(tidyverse)

if(!file.exists(
  here::here("2019-10-15_big-mtcars/big-epa-raw.Rdata")
)) {
  # ref: https://www.fueleconomy.gov/feg/ws/index.shtml#fuelType1
  spec <- list(
    barrels08 = col_double(),
    barrelsA08 = col_double(),
    charge120 = col_double(),
    charge240 = col_double(),
    city08 = col_double(),
    city08U = col_double(),
    cityA08 = col_double(),
    cityA08U = col_double(),
    cityCD = col_double(),
    cityE = col_double(),
    cityUF = col_double(),
    co2 = col_double(),
    co2A = col_double(),
    co2TailpipeAGpm = col_double(),
    co2TailpipeGpm = col_double(),
    comb08 = col_double(),
    comb08U = col_double(),
    combA08 = col_double(),
    combA08U = col_double(),
    combE = col_double(),
    combinedCD = col_double(),
    combinedUF = col_double(),
    cylinders = col_double(),
    displ = col_double(),
    drive = col_character(),
    engId = col_double(),
    eng_dscr = col_character(),
    feScore = col_double(),
    fuelCost08 = col_double(),
    fuelCostA08 = col_double(),
    fuelType = col_character(),
    fuelType1 = col_character(),
    ghgScore = col_double(),
    ghgScoreA = col_double(),
    highway08 = col_double(),
    highway08U = col_double(),
    highwayA08 = col_double(),
    highwayA08U = col_double(),
    highwayCD = col_double(),
    highwayE = col_double(),
    highwayUF = col_double(),
    hlv = col_double(),
    hpv = col_double(),
    id = col_double(),
    lv2 = col_double(),
    lv4 = col_double(),
    make = col_character(),
    model = col_character(),
    mpgData = col_character(),
    phevBlended = col_logical(),
    pv2 = col_double(),
    pv4 = col_double(),
    range = col_double(),
    rangeCity = col_double(),
    rangeCityA = col_double(),
    rangeHwy = col_double(),
    rangeHwyA = col_double(),
    trany = col_character(),
    UCity = col_double(),
    UCityA = col_double(),
    UHighway = col_double(),
    UHighwayA = col_double(),
    VClass = col_character(),
    year = col_double(),
    youSaveSpend = col_double(),
    guzzler = col_character(),
    trans_dscr = col_character(),
    tCharger = col_character(),
    sCharger = col_character(),
    atvType = col_character(),
    fuelType2 = col_character(),
    rangeA = col_character(),
    evMotor = col_character(),
    mfrCode = col_character(),
    c240Dscr = col_character(),
    charge240b = col_double(),
    c240bDscr = col_character(),
    createdOn = col_character(),
    modifiedOn = col_character(),
    startStop = col_character(),
    phevCity = col_double(),
    phevHwy = col_double(),
    phevComb = col_double()
  )

  big_epa_cars_raw <-
    read_csv(
      "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-15/big_epa_cars.csv",
      col_types = spec
    )
} else {
  load(here::here("2019-10-15_big-mtcars/big-epa-raw.Rdata"))
}

# mangle data

big_epa_cars <- big_epa_cars_raw %>%
  mutate_at(vars(matches("^fuelType"), guzzler,
                 trans_dscr, trany, eng_dscr, engId,
                 drive, VClass),
            as.factor) %>%
  mutate(
    startStop = case_when(
      startStop == "Y" ~ TRUE,
      startStop == "N" ~ FALSE,
      TRUE ~ NA
    ),
    hybrid = !is.na(fuelType2),
    feScore = ifelse(feScore == -1, NA, feScore),
    ghgScore = ifelse(ghgScore == -1, NA, ghgScore),
    ghgScoreA = ifelse(ghgScoreA == -1, NA, ghgScoreA),
    co2 = ifelse(co2 == -1, NA, co2),
    co2A = ifelse(co2 == -1, NA, co2A),
    guzzler_tax = (guzzler == "G" | guzzler == "T")
    # createdOn = as.Date(createdOn, format = "%a %b %d %X EST %Y", tz = "EST"),
    # modifiedOn = as.Date(modifiedOn, format = "%a %b %d %X EST %Y", tz = "EST")
  )

# table(big_epa_cars$fuelType1, big_epa_cars$fuelType2, useNA = "ifany")
#
#                     E85 Electricity Natural Gas Propane  <NA>
# Diesel                0           0           0       0  1197
# Electricity           0           0           0       0   209
# Midgrade Gasoline     0           0           0       0   113
# Natural Gas           0           0           0       0    60
# Premium Gasoline    127         101           0       0 11844
# Regular Gasoline   1331          50          20       8 26744

# 100 * sum(big_epa_cars$hybrid) / nrow(big_epa_cars)
# [1] 3.915893


# Note: E85 = 85% ethanol + 15% gasoline

save(
  big_epa_cars_raw,
  file = here::here("2019-10-15_big-mtcars/big-epa-raw.Rdata")
)

save(
  big_epa_cars,
  file = here::here("2019-10-15_big-mtcars/big-epa.Rdata")
)

