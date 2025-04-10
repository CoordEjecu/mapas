library(sf)
library(ggplot2)

# Read the shapefile
shape_data <- st_read("/workdir/data/shp/DISTRITO_FEDERAL.shp")

# Basic plot
plot(shape_data)

# Nicer plot with ggplot2
ggplot() +
  geom_sf(data = shape_data) +
  ggtitle("My Shapefile Map") +
  theme_minimal()
ggsave("borrame.png")