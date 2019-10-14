**vehicle**

- atvtype - type of alternative fuel or advanced technology vehicle
  - Bifuel (CNG) - Bi-fuel gasoline and compressed natural gas vehicle
  - Bifuel (LPG) - Bi-fuel gasoline and propane vehicle
  - CNG - Compressed natural gas vehicle
  - Diesel - Diesel vehicle
  - EV - Electric vehicle
  - FFV - Flexible fueled vehicle (gasoline or E85)
  - Hybrid - Hybrid vehicle
  - Plug-in Hybrid - Plug-in hybrid vehicle
- barrels08 - annual petroleum consumption in barrels for fuelType1 (1)
- barrelsA08 - annual petroleum consumption in barrels for fuelType2 (1)
- charge120 - time to charge an electric vehicle in hours at 120 V
- charge240 - time to charge an electric vehicle in hours at 240 V
- city08 - city MPG for fuelType1 (2), (11)
- city08U - unrounded city MPG for fuelType1 (2), (3)
- cityA08 - city MPG for fuelType2 (2)
- cityA08U - unrounded city MPG for fuelType2 (2), (3)
- cityCD - city gasoline consumption (gallons/100 miles) in charge depleting mode (4)
- cityE - city electricity consumption in kw-hrs/100 miles
- cityUF - EPA city utility factor (share of electricity) for PHEV
- co2 - tailpipe CO2 in grams/mile for fuelType1 (5)
- co2A - tailpipe CO2 in grams/mile for fuelType2 (5)
- co2TailpipeAGpm - tailpipe CO2 in grams/mile for fuelType2 (5)
- co2TailpipeGpm- tailpipe CO2 in grams/mile for fuelType1 (5)
- comb08 - combined MPG for fuelType1 (2), (11)
- comb08U - unrounded combined MPG for fuelType1 (2), (3)
- combA08 - combined MPG for fuelType2 (2)
- combA08U - unrounded combined MPG for fuelType2 (2), (3)
- combE - combined electricity consumption in kw-hrs/100 miles
- combinedCD - combined gasoline consumption (gallons/100 miles) in charge depleting mode (4)
- combinedUF - EPA combined utility factor (share of electricity) for PHEV
- cylinders - engine cylinders
- displ - engine displacement in liters
- drive - drive axle type
  - 2-Wheel Drive
  - 4-Wheel Drive*
  - 4-Wheel or All-Wheel Drive*
  - All-Wheel Drive*
  - Front-Wheel Drive
  - Part-time 4-Wheel Drive*
  - Rear-Wheel Drive
  - *Prior to Model Year 2010, EPA did not differentiate between All Wheel Drive and Four Wheel Drive
- emissionsList
- engId - EPA model type index
- eng_dscr - engine descriptor; see http://www.fueleconomy.gov/feg/findacarhelp.shtml#engine
- evMotor - electric motor (kw-hrs)
- feScore - EPA Fuel Economy Score (-1 = Not available)
- fuelCost08 - annual fuel cost for fuelType1 ($) (7)
- fuelCostA08 - annual fuel cost for fuelType2 ($) (7)
- fuelType - fuel type with fuelType1 and fuelType2 (if applicable)
- fuelType1 - fuel type 1. For single fuel vehicles, this will be the only fuel. For dual fuel vehicles, this will be the conventional fuel.
- fuelType2 - fuel type 2. For dual fuel vehicles, this will be the alternative fuel (e.g. E85, Electricity, CNG, LPG). For single fuel vehicles, this field is not used
- ghgScore - EPA GHG score (-1 = Not available)
- ghgScoreA - EPA GHG score for dual fuel vehicle running on the alternative fuel (-1 = Not available)
- guzzler- if G or T, this vehicle is subject to the gas guzzler tax
- highway08 - highway MPG for fuelType1 (2), (11)
- highway08U - unrounded highway MPG for fuelType1 (2), (3)
- highwayA08 - highway MPG for fuelType2 (2)
- highwayA08U - unrounded highway MPG for fuelType2 (2),(3)
- highwayCD - highway gasoline consumption (gallons/100miles) in charge depleting mode (4)
- highwayE - highway electricity consumption in kw-hrs/100 miles
- highwayUF - EPA highway utility factor (share of electricity) for PHEV
- hlv - hatchback luggage volume (cubic feet) (8)
- hpv - hatchback passenger volume (cubic feet) (8)
- id - vehicle record id
- lv2 - 2 door luggage volume (cubic feet) (8)
- lv4 - 4 door luggage volume (cubic feet) (8)
- make - manufacturer (division)
- mfrCode - 3-character manufacturer code
- model - model name (carline)
- mpgData - has My MPG data; see yourMpgVehicle and yourMpgDriverVehicle
- phevBlended - if true, this vehicle operates on a blend of gasoline and electricity in charge depleting mode
- pv2 - 2-door passenger volume (cubic feet) (8)
- pv4 - 4-door passenger volume (cubic feet) (8)
- rangeA - EPA range for fuelType2
- rangeCityA - EPA city range for fuelType2
- rangeHwyA - EPA highway range for fuelType2
- trans_dscr - transmission descriptor; see http://www.fueleconomy.gov/feg/findacarhelp.shtml#trany
- trany - transmission
- UCity - unadjusted city MPG for fuelType1; see the description of the EPA test procedures
- UCityA - unadjusted city MPG for fuelType2; see the description of the EPA test procedures
- UHighway - unadjusted highway MPG for fuelType1; see the description of the EPA test procedures
- UHighwayA - unadjusted highway MPG for fuelType2; see the description of the EPA test procedures
- VClass - EPA vehicle size class
  - Two-Seaters - Any (cars designed to seat only two adults)
  - Minicompact Cars - Less than 85 cu ft.
  - Subcompact Cars - 85 to 99 cu ft.
  - Compact Cars - 100 to 109 cu ft.
  - Mid-Size Cars - 110 to 119 cu ft.
  - Large Cars - 120 or more cu ft.
  - Small Station Wagons- Less than 130 cu ft.
  - Mid-Size Cars Station Wagons- 130 to 159 cu ft.
  - Large Cars Station Wagons- 160 or more cu ft.
  - Small Pickup Trucks - Less than 4,500 lbs GVWR through Model Year 2007
  - Small Pickup Trucks - Less than 6,000 lbs GVWR after Model Year 2008
  - Standard Pickup Trucks - 4,500 to 8,500 lbs GVWR through Model Year 2007
  - Standard Pickup Trucks - 6,000 to 8,500 lbs GVWR after Model Year 2008
  - Passenger Vans - Less than 8,500 lbs GVWR through Model Year 2010
  - Passenger Vans - Less than 10,000 lbs GVWR beginning Model Year 2011
  - Cargo Vans - Less than 8,500 lbs GVWR
  - Minivans - Less than 8,500 lbs GVWR
  - Sport Utility Vehicles (SUVs) - Less than 8,500 lbs GVWR through Model Year 2010
  - Sport Utility Vehicles (SUVs) - Less than 10,000 lbs GVWR beginning Model Year 2011
  - Small Sport Utility Vehicles (SUVs) - Less than 6,000 lbs GVWR beginning Model Year 2013
  - Standard Sport Utility Vehicles (SUVs) - 6,000 to 10,000 lbs GVWR beginning Model Year 2013
  - Special Purpose Vehicles - Less than 8,500 lbs GVWR through Model Year 2010
  - Special Purpose Vehicles - Less than 10,000 lbs GVWR beginning Model Year 2011
  - *Gross Vehicle Weight Rating (GVWR) is calculated as truck weight plus carrying capacity.
- year - model year
- youSaveSpend - you save/spend over 5 years compared to an average car ($). Savings are positive; a greater amount spent yields a negative number. For dual fuel vehicles, this is the cost savings for gasoline
- sCharger - if S, this vehicle is supercharged
- tCharger - if T, this vehicle is turbocharged
- c240Dscr - electric vehicle charger description
- charge240b - time to charge an electric vehicle in hours at 240 V using the alternate charger
- c240bDscr - electric vehicle alternate charger description
- createdOn - date the vehicle record was created (ISO 8601 format)
- modifiedOn - date the vehicle record was last modified (ISO 8601 format)
- startStop - vehicle has start-stop technology (Y, N, or blank for older vehicles)
- phevCity - EPA composite gasoline-electricity city MPGe for plug-in hybrid vehicles
- phevHwy - EPA composite gasoline-electricity highway MPGe for plug-in hybrid vehicles
- phevComb - EPA composite gasoline-electricity combined city-highway MPGe for plug-in hybrid vehicles

*Footnotes*:

(1) 1 barrel = 42 gallons. Petroleum consumption is estimated using the Department of Energy's GREET model and includes petroleum consumed from production and refining to distribution and final use. Vehicle manufacture is excluded.

(2) The MPG estimates for all 1985-2007 model year vehicles and some 2011-2016 model year vehicles have been updated. Learn More

(3) Unrounded MPG values are not available for some vehicles.

(4) This field is only used for blended PHEV vehicles.

(5) For model year 2013 and beyond, tailpipe CO2 is based on EPA tests. For previous model years, CO2 is estimated using an EPA emission factor. -1 = Not Available.

(6) For PHEVs this is the charge depleting range.

(7) Annual fuel cost is based on 15,000 miles, 55% city driving, and the price of fuel used by the vehicle.

(8) Interior volume dimensions are not required for two-seater passenger cars or any vehicle classified as truck which includes vans, pickups, special purpose vehicles, minivan and sport utility vehicles.

(9) Fuel prices for gasoline and diesel fuel are from the Energy Information Administration and are usually updated weekly.

(10) Fuel prices for E85, LPG, and CNG are from the Office of Energy Efficiency and Renewable Energy's Alternative Fuel Price Report and are updated quarterly.

(11) For electric and CNG vehicles this number is MPGe (gasoline equivalent miles per gallon). 