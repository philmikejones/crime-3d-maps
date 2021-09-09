library("dplyr")
library("sf")
library("assertthat")

# Ensure 01-prep-crime-data.r has been run first
crimes = readRDS("data/interim/crimes.rds")
crimes = st_as_sf(crimes, coords = c("Longitude", "Latitude"))
crimes = st_set_crs(crimes, 4326)


# Open Geography Portal - last updated 2017-10-09
# https://www.arcgis.com/sharing/rest/content/items/c86cdd7f86264f369789752121f0a1c4/info/metadata/metadata.xml?format=default&output=html
if (!file.exists("data/external/boundaries.geojson"))
{
    url = "https://opendata.arcgis.com/datasets/c86cdd7f86264f369789752121f0a1c4_0.geojson"
    download.file(url, destfile = "data/external/boundaries.geojson")
}

boundaries = sf::read_sf("data/external/boundaries.geojson")
boundaries =
    boundaries %>%
    rename(
        id   = OBJECTID,
        code = PFA16CD,
        name = PFA16NM
    ) %>%
    select(id, code, name)

assert_that(all(st_is_valid(boundaries)))

# NB this is lengthS not length
boundaries$num_burglaries = lengths(st_intersects(boundaries, crimes))
boundaries = st_transform(boundaries, crs = 27700)

if (!all(st_is_valid(boundaries)))
{
    boundaries = st_make_valid(boundaries)
}

assert_that(all(st_is_valid(boundaries)))

boundaries = rmapshaper::ms_simplify(boundaries)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
sf::st_write(boundaries, "data/processed/boundaries.gpkg", delete_layer = TRUE)
