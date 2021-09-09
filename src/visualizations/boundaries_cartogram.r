library("dplyr")
library("sf")
library("cartogram")
library("tmap")
library("viridis")

dir.create("docs/visualisations", showWarnings = FALSE, recursive = TRUE)

boundaries = sf::read_sf("data/processed/boundaries.gpkg")
boundaries_cartogram = cartogram::cartogram_cont(boundaries, "num_burglaries")

map = 
    tm_basemap(NULL) +
    tm_shape(boundaries_cartogram) +
    tm_polygons(
        col = "num_burglaries", palette = "viridis",
        popup.vars = c("Constabulary: " = "name", "Burglaries: " = "num_burglaries")
    ) +
    tm_layout(legend.show = FALSE, frame = FALSE)

tmap_save(
    map, "docs/visualisations/burglaries.html",
    height = 1070, units = "px", selfcontained = TRUE
)

write_sf(boundaries_cartogram, "data/processed/boundaries_cartogram.gpkg")
