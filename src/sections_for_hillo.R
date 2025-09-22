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
localidades <- st_read("/workdir/data/26 SONORA/LIMITE_LOCALIDAD.shp")  |>
  dplyr::filter(MUNICIPIO == municipio, NOMBRE == "HERMOSILLO")

id_seccion <- secciones$SECCION

limites_seccion <- sf::st_bbox(localidades)
id_seccion_more_voted <- readr::read_csv("/workdir/data/summary_morena_2024_sonora.csv", show_col_types = FALSE) |>
  dplyr::filter(SECCION %in% id_seccion) |>
  dplyr::arrange(-total) |>
  dplyr::mutate(acumulado = cumsum(total)) |>
  dplyr::filter(acumulado < 221377) |>
  dplyr::pull(SECCION)

secciones <- secciones |>
  dplyr::filter(SECCION %in% id_seccion_more_voted)

cabecera <- stringr::str_to_lower(stringr::str_replace_all(cabeceras$LOCALIDAD_.1, " ", "_"))

entidad <- st_read("/workdir/data/26 SONORA/ENTIDAD.shp")
el_mapita <- ggplot() +
  geom_sf(data = entidad) +
  geom_sf(data = municipios, fill = "black") +
  geom_sf(data = localidades, fill = "white") +
  theme_void()

municipy_map <- glue::glue("/workdir/results/secciones_de_{cabecera}.png")
map_municipy <- ggplot() +
  geom_sf(data = municipios) +
  geom_sf(data = secciones) +
  theme_minimal() +
  coord_sf(
    xlim = c(limites_seccion$xmin, limites_seccion$xmax),
    ylim = c(limites_seccion$ymin, limites_seccion$ymax)
  )
  labs(title = glue::glue("{stringr::str_to_title(cabeceras$LOCALIDAD_.1)}"))

mapa_final <- cowplot::ggdraw() +
  cowplot::draw_plot(map_municipy) +
  cowplot::draw_plot(
    el_mapita,
    x = 0.24, y = 0.05, # Posición del inset (ajusta según necesidad)
    width = 0.2, height = 0.2 # Tamaño del inset
  )

ggsave(mapa_final, filename = municipy_map, width = 8, height = 6)
