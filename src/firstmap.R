library(sf)
library(ggplot2)

# Read the shapefile
municipios <- st_read("/workdir/data/26 SONORA/MUNICIPIO.shp")

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
