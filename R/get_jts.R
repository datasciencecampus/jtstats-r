#' Get JTS data
#'
#' @param type What type of JTS data is of interest? One of
#'   "jts01" "jts02" "jts03" "jts04" "jts05" "jts09" "jts10"
#'   jts05, Journey times to key services by lower super output area (JTS05),
#'   provided by default
#' @param purpose The purpose or text string matching the table of interest.
#'   Purpose can match 'trip attractors' for which journey time
#'   statistics are required such as
#'   employment
#'   primary
#'   secondary
#'   further
#'   gps
#'   hospitals
#'   food
#'   town
#'   pharmacy.
#'   The text string can also match unique strings to identify tables in each
#'   table type, e.g. setting this to 'rural' when type is set to 'jts01'
#'   will match the table
#'   JTS0102: Average minimum travel time to reach the nearest key services by
#'   mode of travel, rural and urban areas: England.
#' @param sheet The sheet within the JTS dataset for which data is required.
#'   Can be a year, with 2014 2015 2016 2017 or 2019 (the default), or a
#'   text string to identify a particular sheet (e.g. "meta" to get metadata tables)
#' @param code If you already know the JTS table code you're after
#' @param file_name If you know the unique file name of the JTS table you're after
#' @param base_url Where to get the data from
#' @export
#' @examples
#' employment_2017 = get_jts(type = "jts04", purpose = "employment", sheet = 2017)
#' dim(employment_2017)
#' names(employment_2017)
#' nrow(employment_2017) # 32844
#' employment_2017[1:3, 1:8]
#' employment_metadata = get_jts(type = "jts04", purpose = "employment", sheet = "meta")
#' # View(employment_metadata)
#' primary_2017 = get_jts(type = "jts04", purpose = "prim", sheet = 2017)
#' # View(employment_2017) # View results
#' employment_2017_lsoa = get_jts(type = "jts05", purpose = "employment", sheet = 2017)
#' # get_jts(sheet = "0") # Error message
#' gps_2017 = get_jts(purpose = "gp", sheet = 2017)
#' # gps_2017 = get_jts(purpose = "gp", sheet = 2017,
#' #   base_url = "~/github/datasciencecampus/jtstats/raw_jts_data/jts_csv_files/")
#' town = get_jts(purpose = 'town')
#' # get_jts(type = "jts01", sheet = "by mode") # asks for more info
#' # get_jts(type = "jts01", sheet = "by mode of travel, local authority", purpose = "")
#' jts_01_rural_2015 = get_jts(type = "jts01", purpose = "rural", sheet = "2015")
#'
#' # Match based on file name:
#' head(jts_tables$csv_file)
#' get_jts(file_name = "jts0102-2014")
get_jts = function(
    type = "jts04",
    purpose = "",
    sheet = "2019",
    code = "",
    file_name = NULL,
    base_url = "https://github.com/ITSLeeds/jts/releases/download/2/"
    ) {
  # Could add other acceptable values:
  valid_sheet = as.character(sheet) %in% c(as.character(jts_params$year), "meta")
  if(!valid_sheet) {
    warning("May be invalid sheet (should be a year or text string matching a sheet")
  }
  if(!is.null(file_name)) {
    match_file = grepl(file_name, x = jts_tables$csv_file, ignore.case = TRUE)
    jts_sel = jts_tables[match_file, ]
  } else {
    jts_sel = lookup_jts_table(type, purpose, sheet, code)
  }
  n_sheets = nrow(jts_sel)
  if(n_sheets != 1) {
    stop("Multiple matching sheets, try different inputs!")
  }
  download_url = paste0(base_url, jts_sel$csv_file)
  # download_url = "https://github.com/ITSLeeds/jts/releases/download/2/jts0101-JTS0101.csv"
  skip = skip_n(jts_sel$table_type, jts_sel$sheet, jts_sel$csv_file)
  suppressMessages({
    jts_data = readr::read_csv(download_url, skip = skip)
  })
  clean_jts(jts_data)
}

#' Find specific jts table and sheet
#'
#' @inheritParams get_jts
#' @export
#' @examples
#' lookup_jts_table()
#' lookup_jts_table(purpose = "employment", sheet = 2017)
#' jdf = lookup_jts_table(purpose = "employment", sheet = 2019)
#' jdf$table_url
#' # browseURL(jdf$table_url)
#' lookup_jts_table(type = "jts01", purpose = "rural")
#' lookup_jts_table(purpose = "gp", sheet = "meta")
#' lookup_jts_table(type = "jts05", purpose = "employment", sheet = "meta")
lookup_jts_table = function(type = "", purpose = "", sheet = "", code = "") {
  tables_selected = jts_tables
  if(type != "") {
    match_type = grepl(type, x = tables_selected$table_type, ignore.case = TRUE)
    tables_selected = tables_selected[match_type, ]
    message("Matching tables by type (", type, "):\n",
            paste0(unique(tables_selected$table_title), collapse = "\n"))
  }
  if(purpose != "") {
    match_purposes = grepl(purpose, x = tables_selected$table_title, ignore.case = TRUE)
    tables_selected = tables_selected[match_purposes, ]
    message("\nMatching tables by purpose (", type, "):\n",
            paste0(unique(tables_selected$table_title), collapse = "\n"))
  }
  if(code != "") {
    match_code = grepl(code, x = tables_selected$table_code, ignore.case = TRUE)
    tables_selected = tables_selected[match_code, ]
    message("\nMatching tables by code (", type, ", ", purpose, ", ", code, "):\n",
            paste0(unique(tables_selected$table_code), collapse = "\n"))
  }
  if(sheet != "") {
    match_sheet = grepl(sheet, x = tables_selected$csv_file, ignore.case = TRUE)
    tables_selected = tables_selected[match_sheet, ]
    message("\nMatching tables by sheet (", type, ", ", purpose, ", ", sheet, "):\n",
            paste0(unique(tables_selected$csv_file), collapse = "\n"))
    }
  tables_selected
}



clean_jts = function(d) {
  # Remove faulty names:
  # reg_text = "\\.\\.\\.[1-8]|Year"
  # d = d[!grepl(pattern = reg_text, x = names(d))]
  columns_mostly_na = sapply(d, function(x) sum(is.na(x)) / length(x) > 0.6)
  d[!columns_mostly_na]
}

#' Get metadata associated with a particular JTS table
#'
#' @inheritParams get_jts
#' @export
#' @examples
#' get_jts_metadata(type = "jts05", purpose = "employment")
get_jts_metadata = function(type = "jts05", purpose = "employment", sheet = "meta",
                            base_url = "https://github.com/ITSLeeds/jts/releases/download/2/") {
  jts_sel = lookup_jts_table(type = type, purpose = purpose, sheet = sheet)
  download_url = paste0(base_url, jts_sel$csv_file)
  # download_url = "https://github.com/ITSLeeds/jts/releases/download/2/jts0101-JTS0101.csv"
  metadata_raw = readr::read_csv(download_url, skip = 33)
  metadata = metadata_raw[c("Field", "Alternate Name", "Description", "Parameter value")]
  # View(metadata_raw)
  metadata
}

# todo: add this function
# view_jts_raw()
# view_jts_raw = function(type = "jts05", purpose = "", sheet = 2019) {
#   match_type = grepl(type, x = jts_tables$table_type, ignore.case = TRUE)
#   tables_type = jts_tables[match_type, ]
#   message("Matching tables by type (", type, "):\n",
#           paste0(unique(tables_type$table_title), collapse = "\n"))
#
#   match_purposes = grepl(purpose, x = tables_type$table_title, ignore.case = TRUE)
#   tables_purpose = tables_type[match_purposes, ]
#   message("\nMatching tables by purpose (", type, "):\n",
#           paste0(unique(tables_purpose$table_title), collapse = "\n"))
# }


# Allow use of global variable
utils::globalVariables(c("jts_tables", "jts_params"))

#' JTS tables
#'
#' The complete list of JTS tables represented as named sheets from the ODS files
#' @examples
#' jts_tables
"jts_tables"

#' JTS table paramets
#'
#' The complete list of JTS tables represented as named sheets from the ODS files
#' @examples
#' jts_params
"jts_params"

skip_n = function(type, sheet, csv_file) {
  if(grepl(pattern = "01|02|03", x = type)) {
    skip = 7
    if(grepl(pattern = "REVISED", x = sheet)) {
      skip = 9
    }
  } else if(grepl(pattern = "04|05|09|10", x = type)) {
    skip = 6
    if(grepl(pattern = "meta", x = sheet, ignore.case = TRUE)) {
      skip = 30
    }
    # selected file is GPs
    if(grepl(pattern = "jts0405", x = csv_file, ignore.case = TRUE)) {
      skip = 7
    }
  } else if(grepl(pattern = "01|02|03", x = type)) {
    skip = 7
  } else {
    skip = 0
  }
  skip
}
