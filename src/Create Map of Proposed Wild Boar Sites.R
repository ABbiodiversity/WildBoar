# Create map of Wild Boar camera sites

library(leaflet)
library(leaflet.extras)
library(sf)

g_drive <- "G:/Shared drives/ABMI Camera Mammals/Projects/Wild Boar/"

# Sites
sites <- st_read(paste0(g_drive, "Selected Sampling Points with Attributes v3.shp")) |>
  st_transform(4326)

cam <- makeAwesomeIcon(
  icon = "camera",
  iconColor = "black",
  library = "ion",
  markerColor = "white"
)

parks <- st_read(paste0(g_drive, "EINP CLB.shp")) |> st_transform(4326)

# Create map

map <- parks |>
  leaflet() |>
  addTiles() |>
  addProviderTiles("Esri.WorldImagery",
                   group = "Satellite Imagery") |>
  addFullscreenControl() |>
  addResetMapButton() |>
  addScaleBar(position = "bottomleft",
              options = scaleBarOptions(imperial = FALSE)) |>
  addMeasure(position = "topleft",
             primaryLengthUnit = "meters",
             primaryAreaUnit = "sqmeters",
             secondaryLengthUnit = "kilometers",
             secondaryAreaUnit = "sqkilometers",
             activeColor = "cornflowerblue",
             completedColor = "cornflowerblue") |>
  addDrawToolbar(position = "topleft",
                 polylineOptions = FALSE,
                 polygonOptions = FALSE,
                 circleOptions = FALSE,
                 rectangleOptions = FALSE,
                 circleMarkerOptions = FALSE,
                 markerOptions = drawMarkerOptions(repeatMode = TRUE, markerIcon = cam),
                 editOptions = editToolbarOptions(edit = TRUE, remove = TRUE)) |>

  addPolygons(color = "darkred",
              weight = 2,
              smoothFactor = 0.2,
              opacity = 2,
              fill = FALSE,
              group = "Park Boundaries") |>

  addAwesomeMarkers(data = sites,
                    icon = cam,
                    group = "Proposed Camera Locations",
                    # options = leafletOptions(pane = "Proposed Cameras"),
                    popup = paste("Location: ", "<b>", sites$GRID_ID, "</b>",
                                  "<br>", "<br>",
                                  "Notes:", "<br>"
                    )) |>

  addLayersControl(overlayGroups = c("Satellite Imagery",
                                     "Proposed Camera Locations"),
                   options = layersControlOptions(collapsed = FALSE),
                   position = "topright") |>

  hideGroup("")

map

# Save map
htmlwidgets::saveWidget(map, file = "./docs/WildBoar_ProposedSites.html", selfcontained = FALSE)


