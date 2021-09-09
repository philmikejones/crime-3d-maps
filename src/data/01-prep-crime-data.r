library("assertthat")
library("dplyr")
library("readr")

# Download crime data from data.police.uk
# Here I've downloaded all crime for the 11 months August 2018 - June 2019
# Why not more recent? Greater Manchester don't report any crimes from July 2019
# onwards
# Why not 12 months (i.e. from July 2018)? Data doesn't go back that far
# https://data.police.uk/changelog/
dir.create("data/external/crimes", showWarnings = FALSE, recursive = TRUE)

if (length(list.files("data/external/crimes", recursive = TRUE)) < 1L)
{
    unzip(
        "data/external/0256321538e3cbb59afe05d8eed2d6cea5274e66.zip",
        exdir = "data/external/crimes"
    )
}

crimes = list.files("data/external/crimes", recursive = TRUE, full.names = TRUE)
crimes = lapply(crimes, read_csv, show_col_types = FALSE)
crimes = bind_rows(crimes)

assert_that(sum(str_detect(crimes$`Falls within`, "Manchester")) >= 1L)

crimes = 
    crimes %>%
    filter(`Crime type` == "Burglary") %>%
    filter(!is.na(Longitude)) %>%
    select(`Crime ID`, Longitude, Latitude, `LSOA code`, `Crime type`)

dir.create("data/interim", showWarnings = FALSE, recursive = TRUE)
saveRDS(crimes, "data/interim/crimes.rds")
