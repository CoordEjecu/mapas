library(sf)
library(ggplot2)

# Read the shapefile
distritos <- st_read("/workdir/data/26 SONORA/DISTRITO_FEDERAL.shp") |>
  dplyr::filter(DISTRITO == 4)
manzanas <- st_read("/workdir/data/26 SONORA/FERROCARRIL.shp")
municipios <- st_read("/workdir/data/26 SONORA/MUNICIPIO.shp") |>
  dplyr::filter(NOMBRE == "HERMOSILLO")
escuelas <- st_read("/workdir/data/26 SONORA/ESCUELA.shp")


# Nicer plot with ggplot2
ggplot() +
  geom_sf(data = distritos) +
  geom_sf(data = manzanas, fill = "blue", color = "darkblue", alpha = 0.5) +
  geom_sf(data = municipios, fill = "yellow", color = "darkblue") +
  geom_sf(data = escuelas, color = "red", size = 2) +
  ggtitle("My Shapefile Map") +
  theme_minimal()
ggsave("borrame.png")