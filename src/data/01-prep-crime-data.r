library("dplyr")
library("readr")

# Download crime data from data.police.uk
# Here I've downloaded all crime for the 12 months January - December 2020
# for all forces
dir.create("data/external/crimes", showWarnings = FALSE, recursive = TRUE)

if (length(list.files("data/external/crimes", recursive = TRUE)) < 1L)
{
    unzip(
        "data/external/926a6fb5fc9ef52299cbe0134e9faa7efbd3d253.zip",
        exdir = "data/external/crimes"
    )
}

crimes = list.files("data/external/crimes", recursive = TRUE, full.names = TRUE)
crimes = lapply(crimes, read_csv)
crimes = bind_rows(crimes)
crimes = 
    crimes %>%
    filter(`Crime type` == "Burglary") %>%
    select(`Crime ID`, Longitude, Latitude, `LSOA code`, `Crime type`)

dir.create("data/interim", showWarnings = FALSE, recursive = TRUE)
saveRDS(crimes, "data/interim/crimes.rds")
