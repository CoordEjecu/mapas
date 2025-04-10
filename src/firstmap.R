library(sf)
library(ggplot2)

# Read the shapefile
distritos <- st_read("/workdir/data/shp/DISTRITO_FEDERAL.shp")
manzanas <- st_read("/workdir/data/shp/MANZANA.shp")

# Basic plot
plot(shape_data)

# Nicer plot with ggplot2
ggplot() +
  geom_sf(data = distritos) +
  geom_sf(data = manzanas, fill = "blue", color = "darkblue", alpha = 0.5) +
  ggtitle("My Shapefile Map") +
  theme_minimal()
ggsave("borrame.png")