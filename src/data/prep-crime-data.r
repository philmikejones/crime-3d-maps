# Download crime data from data.police.uk
# Here I've downloaded all crime for the 12 months January - December 2020
# for all forces
dir.create("data/external/crimes", showWarnings = FALSE, recursive = TRUE)

unzip(
    "data/external/926a6fb5fc9ef52299cbe0134e9faa7efbd3d253.zip",
    exdir = "data/external/crimes"
)

download.file(
    "https://data.police.uk/data/boundaries/force_kmls.zip",
    destfile = "data/external/force_kmls.zip"
)

unzip(
    "data/external/force_kmls.zip",
    exdir = "data/external"
)
