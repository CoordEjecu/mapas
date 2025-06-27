library(sf)
library(ggplot2)

# Read the shapefile
distritos <- st_read("/workdir/data/26 SONORA/DISTRITO_FEDERAL.shp")
manzanas <- st_read("/workdir/data/26 SONORA/MANZANA.shp")


# Nicer plot with ggplot2
ggplot() +
  geom_sf(data = distritos) +
  geom_sf(data = manzanas, fill = "blue", color = "darkblue", alpha = 0.5) +
  ggtitle("My Shapefile Map") +
  theme_minimal()
ggsave("borrame.png")