library(sf)
library(ggplot2)


id_name <- jsonlite::fromJSON("tests/data/id_name_municipies.json")
municipio <- id_name$HERMOSILLO
# Read the shapefile
municipios <- sf::st_read("/workdir/data/26 SONORA/MUNICIPIO.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
cabeceras <- st_read("/workdir/data/26 SONORA/CABECERA_MUNICIPAL.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
secciones <- st_read("/workdir/data/26 SONORA/SECCION.shp") |>
  dplyr::filter(MUNICIPIO == municipio, TIPO == 2)
id_seccion <- secciones$SECCION

id_seccion_more_voted <- readr::read_csv("/workdir/data/summary_morena_2024_sonora.csv", show_col_types = FALSE) |>
  dplyr::filter(SECCION %in% id_seccion) |>
  dplyr::arrange(-total) |>
  dplyr::mutate(acumulado = cumsum(total)) |>
  dplyr::filter(acumulado < 221377) |>
  dplyr::pull(SECCION)

secciones <- secciones |>
  dplyr::filter(SECCION %in% id_seccion_more_voted)

cabecera <- stringr::str_to_lower(stringr::str_replace_all(cabeceras$LOCALIDAD_.1, " ", "_"))

municipy_map <- glue::glue("/workdir/results/secciones_de_{cabecera}.png")
map_municipy <- ggplot() +
  geom_sf(data = localidad) +
  geom_sf(data = secciones) +
  theme_minimal() +
  labs(title = glue::glue("{stringr::str_to_title(cabeceras$LOCALIDAD_.1)}"))
