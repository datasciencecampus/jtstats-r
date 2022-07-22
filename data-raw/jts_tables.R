## code to prepare `jts_tables` dataset goes here
library(tidyverse)
jts_tables = readr::read_csv("../accessibility_table_csv.csv")
jts_tables = jts_tables %>%
  mutate(table_type_code = tolower(str_sub(string = table_code, start = 1, end = 5))) %>%
  mutate(sheet = gsub(pattern = ".csv", replacement = "", x = csv_file)) %>%
  mutate(csv_file = paste(table_code, csv_file, sep = "-"))
jts_tables$csv_file

table_type = c(
  "Journey times to key services (JTS01)",
  "User access to key services by journey time (JTS02)",
  "Number of key services by journey time (JTS03)",
  "Journey times to key services by local authority (JTS04)",
  "Journey times to key services by lower super output area (JTS05)",
  "Journey times connectivity (JTS09)",
  "Ad hoc journey times analysis (JTS10)"
  )
table_type_code = str_extract(table_type, pattern = "JTS..") %>%
  tolower()
jts_table_types = tibble(table_type, table_type_code)
jts_tables = left_join(jts_tables, jts_table_types)
jts_tables = jts_tables %>%
  select(table_type, table_title, table_code, sheet, csv_file, table_url)
readr::write_csv(jts_tables, "../jts_tables.csv")
readr::write_csv(jts_table_types, "../jts_table_types.csv")

jts_params = list(
  type = table_type_code,
  year = c(2014:2017, 2019),
  purpose = c("employment", "primary", "secondary", "further", "gps", "hospitals", "food", "town", "pharmacy"),
  table_code = unique(jts_tables$table_code),
  table_code = unique(jts_tables$csv_file)
)
usethis::use_data(jts_params, overwrite = TRUE)
usethis::use_data(jts_tables, overwrite = TRUE)
