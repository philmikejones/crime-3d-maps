library("assertthat")
library("dplyr")
library("sf")
library("readxl")

if (!file.exists("data/external/england_msoa_2011.shp"))
{    
    url = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/England_msoa_2011.zip"
    download.file(url, destfile = "data/external/England_msoa_2011.zip")
    unzip("data/external/England_msoa_2011.zip", exdir = "data/external")
}

if (!file.exists("data/external/wales_msoa_2011.shp"))
{
    url = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/Wales_msoa_2011.zip"
    download.file(url, destfile = "data/external/Wales_msoa_2011.zip")
    unzip("data/external/Wales_msoa_2011.zip", exdir = "data/external")
}

if (!file.exists("data/external/msoa-population-estimates-2019.xlsx"))
{
    url = "https://www.nomisweb.co.uk/livelinks/15606.xlsx"
    download.file(url, destfile = "data/external/msoa-population-estimates-2019.xlsx")
}

msoa = bind_rows(
    read_sf("data/external/england_msoa_2011.shp"),
    read_sf("data/external/wales_msoa_2011.shp")
)

msoa = suppressWarnings(st_centroid(msoa))


population = 
    read_excel("data/external/msoa-population-estimates-2019.xlsx", skip = 6) %>% 
    rename(
        msoa_name  = `2011 super output area - middle layer`,
        msoa_code  = `...2`,
        population = `All Ages`
    )

population = left_join(msoa, population, by = c("code" = "msoa_code"))

assert_that(!any(is.na(population$population)))

saveRDS(population, "data/interim/population.rds")
