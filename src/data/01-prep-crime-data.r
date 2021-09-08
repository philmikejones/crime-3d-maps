library("dplyr")
library("sf")

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
