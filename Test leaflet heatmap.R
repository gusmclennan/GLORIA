library(leaflet)
library(leaflet.extras)
library(V8)
library(dplyr)
library(sp)
library(magrittr)

listing_data <- read.csv("D://BRI/03 - BRI Data Products/GLORIA geospatial model/Dev/data/242_Exhibition/242Exhib_ind_points.csv", header = TRUE, stringsAsFactors = FALSE)

names(listing_data)[8:9] <- c("ANZSIC_Code_4", "ANZSIC_Code_Desc")
names(listing_data)[11:12] <- c("lng", "lat")

cafes <- subset(listing_data, listing_data$ANZSIC_Code_Desc == "Cafes and Restaurants")

leaflet(cafes) %>% 
    addProviderTiles(providers$Stamen.Toner) %>%
                addMarkers(lat = ~lat, lng = ~lng, label = listing_data$Trading.name) %>%
    #                setView(data = listing_data, zoom = 12)
    addHeatmap(lng= ~lng, lat = ~lat, blur = 40, max = 0.25, radius = 40)



# Different heatmap call that often crashes R Studio
jsURL <- 'http://leaflet.github.io/Leaflet.markercluster/example/realworld.10000.js'
v8 <- V8::v8()
v8$source(jsURL)

df <- data.frame(v8$get('addressPoints')[,c(1,2)], stringsAsFactors = F) %>%
    dplyr::mutate_each(dplyr::funs(as.numeric))
colnames(df) <- c('lat','lng')

leaflet(df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addWebGLHeatmap(lng=~lng, lat=~lat,size=1000)
