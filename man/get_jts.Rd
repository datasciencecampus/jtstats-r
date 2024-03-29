% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_jts.R
\name{get_jts}
\alias{get_jts}
\title{Get JTS data}
\usage{
get_jts(
  type = "jts04",
  purpose = "",
  sheet = "2019",
  code = "",
  file_name = "",
  base_url = "https://github.com/ITSLeeds/jts/releases/download/2/",
  geo = FALSE
)
}
\arguments{
\item{type}{What type of JTS data is of interest? One of
"jts01" "jts02" "jts03" "jts04" "jts05" "jts09" "jts10"
jts05, Journey times to key services by lower super output area (JTS05),
provided by default}

\item{purpose}{The purpose or text string matching the table of interest.
Purpose can match 'trip attractors' for which journey time
statistics are required such as
employment
primary
secondary
further
gps
hospitals
food
town
pharmacy.
The text string can also match unique strings to identify tables in each
table type, e.g. setting this to 'rural' when type is set to 'jts01'
will match the table
JTS0102: Average minimum travel time to reach the nearest key services by
mode of travel, rural and urban areas: England.}

\item{sheet}{The sheet within the JTS dataset for which data is required.
Can be a year, with 2014 2015 2016 2017 or 2019 (the default), or a
text string to identify a particular sheet (e.g. "meta" to get metadata tables)}

\item{code}{If you already know the JTS table code you're after}

\item{file_name}{If you know the unique file name of the JTS table you're after.
This is provided as a character string with two components: the
JTS table code such as jts0102 and the sheet such as the year or metadata
within the JTS spreadsheet. \code{"jts0102-2014"}, for example,
refers to the sheet 2014 in the JTS spreadsheet JTS0102
(Average minimum travel time to reach the nearest key services by mode of
travel, rural and urban areas: England).}

\item{base_url}{Where to get the data from}

\item{geo}{Return geographic data, as sf objects? FALSE by default.}
}
\value{
A data frame containing journey time statistics
}
\description{
Get JTS data
}
\examples{
jts_tables
# If you already know the code you want:
\dontrun{
jts0101_data = get_jts(code = "JTS0101", sheet = "JTS0101")
employment_2017 = get_jts(type = "jts04", purpose = "employment", sheet = 2017)
dim(employment_2017)
names(employment_2017)
employment_2017[1:3, 1:8]
employment_metadata = get_jts(type = "jts04", purpose = "employment", sheet = "meta")
# View(employment_metadata)
primary_2017 = get_jts(type = "jts04", purpose = "prim", sheet = 2017)
# View(employment_2017) # View results
# employment_2017_lsoa = get_jts(type = "jts05", purpose = "employment", sheet = 2017)
# get_jts(sheet = "0") # Error message
gps_2017 = get_jts(purpose = "gp", sheet = 2017)
# gps_2017 = get_jts(purpose = "gp", sheet = 2017,
#   base_url = "~/github/datasciencecampus/jtstats/raw_jts_data/jts_csv_files/")
town = get_jts(purpose = 'town')
# get_jts(type = "jts01", sheet = "by mode") # asks for more info
# get_jts(type = "jts01", sheet = "by mode of travel, local authority", purpose = "")
jts_01_rural_2015 = get_jts(type = "jts01", purpose = "rural", sheet = "2015")

# Match based on file name:
head(jts_tables$csv_file)
get_jts(file_name = "jts0102-2014")

# Get geo data
employment_2017_geo = get_jts(type = "jts04", purpose = "employment",
  sheet = 2017, geo = TRUE)
class(employment_2017_geo)
plot(employment_2017_geo["100EmpCyc15pct"])
# LSOA data, commented because it's slow
# lsoa_geo = get_jts(type = "jts05", purpose = "employment", sheet = 2017, geo = TRUE)
# class(lsoa_geo)
# plot(lsoa_geo[1:99, 12:15])
}
}
