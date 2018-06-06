library(plyr)
library(fuzzyjoin)
library(dplyr)
setwd("/Users/ak/Desktop/Tableau/World_Happiness/data_prep_whappiness")
country_facts <- data.frame(read.csv("countries_of_the_world.csv", header = TRUE, sep = ","))
unemployment_country <- data.frame(read.csv("unemployment.csv", header = TRUE, sep = ","))
cpi_country <- data.frame(read.csv("index.csv", header = TRUE, sep = ","))
hs_country <- data.frame(read.csv("2016.csv", header = TRUE, sep = ","))
country_facts$country <- country_facts$Country
country_facts$Country <- NULL
facts_unemployment_lo_join <- country_facts %>% regex_left_join(unemployment_country, by = c(country = "country"))

cpi_country$country <- cpi_country$Country
cpi_country$Country <- NULL
cpi_lo_join <- facts_unemployment_lo_join %>% regex_left_join(cpi_country, by = c(country.x = "country"))

hs_country$country <- hs_country$Country
hs_country$Country <- NULL
final_data_set <- cpi_lo_join %>% regex_left_join(hs_country, by = c(country.x = "country"))

write.csv(final_data_set, file = "full_country_data.csv")