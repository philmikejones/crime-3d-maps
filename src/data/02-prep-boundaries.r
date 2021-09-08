library("dplyr")
library("sf")

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
    st_transform(crs = 27700)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
sf::st_write(boundaries, "data/processed/boundaries.gpkg", delete_layer = TRUE)
