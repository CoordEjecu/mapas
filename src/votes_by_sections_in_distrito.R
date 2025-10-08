library(sf)
library(ggplot2)

secciones <- st_read("/workdir/data/26 SONORA/SECCION.shp") |>
  dplyr::filter(DISTRITO == 4) |>
  dplyr::pull(SECCION)

ayuntamiento <- readr::read_csv("data/AYUNTAMIENTO_2024.csv", show_col_types = FALSE) |>
  dplyr::filter(seccion %in% secciones)

total_de_votos_efectivos <- sum(ayuntamiento$total_votos, na.rm = TRUE)

name_municipies_with_80 <- ayuntamiento |>
  dplyr::group_by(municipio) |>
  dplyr::summarise(
    total = sum(total_votos, na.rm = TRUE),
    .groups = "drop"
  ) |>
  dplyr::arrange(-total) |>
  dplyr::mutate(acumulado = cumsum(total)) |>
  dplyr::filter(acumulado <= total_de_votos_efectivos * 0.8) |>
  dplyr::pull(municipio)

municipios <- sf::st_read("/workdir/data/26 SONORA/MUNICIPIO.shp") |>
  dplyr::filter(NOMBRE %in% name_municipies_with_80) |>
  dplyr::mutate(
    centroide = st_centroid(geometry),
    lon = st_coordinates(centroide)[, 1],
    lat = st_coordinates(centroide)[, 2]
  )

entidad <- st_read("/workdir/data/26 SONORA/ENTIDAD.shp")
color_pantone <- "#9D2449"
el_mapita <- ggplot() +
  geom_sf(data = entidad) +
  geom_sf(data = municipios, fill = color_pantone) +
  geom_text(
    data = municipios,
    aes(x = lon, y = lat, label = MUNICIPIO),
    size = 2,
    color = "black",
    fontface = "bold"
  ) +
  theme_minimal()

municipy_map <- glue::glue("/workdir/results/municipios_copn_el_80_de_votos_2024.png")

ggsave(el_mapita, filename = municipy_map, width = 8, height = 6)
