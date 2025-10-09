library(sf)
library(ggplot2)
source("/workdir/R/works_with_metadata.R")

secciones <- sf::st_read("/workdir/data/26 SONORA/SECCION.shp") |>
  dplyr::filter(DISTRITO == 4) |>
  dplyr::pull(SECCION)
metadatos <- jsonlite::read_json("data/datapackage.json")
recurso <- metadatos$resources[[2]]
schema <- recurso$schema
path <- recurso$path
section_name <- get_name_from_standard_name(schema, "section")
ayuntamiento <- readr::read_csv(path, show_col_types = FALSE) |>
  dplyr::filter(!!rlang::sym(section_name) %in% secciones)
total_votes_name <- get_name_from_standard_name(schema, "total_votes")
total_de_votos_efectivos <- sum(ayuntamiento[[total_votes_name]], na.rm = TRUE)
municipality_name <- get_name_from_standard_name(schema, "municipality")
name_municipies_with_80 <- ayuntamiento |>
  dplyr::group_by(!!rlang::sym(municipality_name)) |>
  dplyr::summarise(
    total = sum(!!rlang::sym(total_votes_name), na.rm = TRUE),
    .groups = "drop"
  ) |>
  dplyr::arrange(-total) |>
  dplyr::mutate(acumulado = cumsum(total)) |>
  dplyr::filter(acumulado <= total_de_votos_efectivos * 0.8) |>
  dplyr::pull(!!rlang::sym(municipality_name))

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
