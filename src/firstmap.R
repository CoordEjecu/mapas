library(sf)
library(ggplot2)

# Read the shapefile
distritos <- st_read("/workdir/data/26 SONORA/DISTRITO_FEDERAL.shp") |>
  dplyr::filter(DISTRITO == 4)
manzanas <- st_read("/workdir/data/26 SONORA/FERROCARRIL.shp")
municipios <- st_read("/workdir/data/26 SONORA/MUNICIPIO.shp")
escuelas <- st_read("/workdir/data/26 SONORA/ESCUELA.shp")

porcentajes <- readr::read_csv("/workdir/data/REPORTE_AFILIACION_04_MUN.csv", show_col_types = FALSE) |>
  dplyr::mutate(
    porc = 100 * AVANCE / META,
    categoria = dplyr::case_when(
      porc >= 90 ~ "90-100 (Verde)",
      porc >= 50 ~ "50-89 (Naranja)",
      TRUE ~ "0-49 (Rojo)"
    )
  )

colores <- c(
  "0-49 (Rojo)" = "#FF0000", # Rojo
  "50-89 (Naranja)" = "#FFA500", # Naranja
  "90-100 (Verde)" = "#00FF00" # Verde
)
completos <- porcentajes |>
  dplyr::left_join(municipios, by = c("MUNICIPIO" = "NOMBRE"))
# Nicer plot with ggplot2
ggplot() +
  geom_sf(data = distritos) +
  geom_sf(data = manzanas, fill = "blue", color = "darkblue", alpha = 0.5) +
  geom_sf(data = municipios, fill = "yellow", color = "darkblue") +
  geom_sf(data = escuelas, color = "red", size = 2) +
  ggtitle("My Shapefile Map") +
  theme_minimal()
ggsave("borrame.png")

ggplot(completos) +
  geom_sf(data = municipios) +
  geom_sf(aes(geometry = geometry, fill = categoria)) +
  scale_fill_manual(
    name = "Rangos",
    values = colores,
    drop = FALSE
  ) +
  theme_minimal() +
  labs(title = "Municipios por rangos de valor")
ggsave("/workdir/borrame_cc.png")
