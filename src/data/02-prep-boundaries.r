library("dplyr")
library("sf")
library("assertthat")

# Ensure 01-prep-crime-data.r has been run first
crimes = readRDS("data/interim/crimes.rds")
crimes = st_as_sf(crimes, coords = c("Longitude", "Latitude"))
crimes = st_set_crs(crimes, 4326)


if (!file.exists("data/external/force_kmls.zip"))
{
    download.file(
        "https://data.police.uk/data/boundaries/force_kmls.zip",
        destfile = "data/external/force_kmls.zip"
    )

    unzip(
        "data/external/force_kmls.zip",
        exdir = "data/external"
    )
}

boundaries = list.files("data/external/force kmls", pattern = ".kml", full.names = TRUE)
boundaries = lapply(boundaries, sf::read_sf)
boundaries = bind_rows(boundaries)
boundaries = 
    boundaries %>%
    mutate(area = sf::st_area(boundaries)) %>%
    arrange(area) %>%
    mutate(id = row_number()) %>%
    select(id, area) %>%
    filter(id != 44) %>%
    st_zm(drop = TRUE)

# NB this is lengthS not length
boundaries$num_burglaries = lengths(st_intersects(boundaries, crimes))

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
sf::st_write(boundaries, "data/processed/boundaries.gpkg", delete_layer = TRUE)
