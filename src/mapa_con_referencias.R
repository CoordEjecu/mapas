library(sf)
library(ggplot2)

id_name <- jsonlite::fromJSON("tests/data/id_name_municipies.json")
municipio <- id_name$BACUM
# Read the shapefile
municipios <- sf::st_read("/workdir/data/26 SONORA/MUNICIPIO.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
cabeceras <- sf::st_read("/workdir/data/26 SONORA/CABECERA_MUNICIPAL.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
secciones <- sf::st_read("/workdir/data/26 SONORA/SECCION.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
id_seccion <- secciones$SECCION
cabecera <- stringr::str_to_lower(stringr::str_replace_all(cabeceras$LOCALIDAD_.1, " ", "_"))
sections_with_votes_path <- glue::glue("/workdir/results/sections_with_votes_{cabecera}.csv")
sections_with_votes <- readr::read_csv("/workdir/data/sections_with_votes.csv", show_col_types = FALSE) |>
  dplyr::filter(SECCION %in% id_seccion) |>
  readdp::write_csv(sections_with_votes_path)

municipy_map <- glue::glue("/workdir/results/secciones_de_{cabecera}.png")
map_municipy <- ggplot() +
  geom_sf(data = municipios) +
  geom_sf(data = secciones) +
  geom_sf(
    data = cabeceras,
    shape = "★", # Símbolo de estrella (unicode)
    color = "black", # Color dorado
    size = 10, # Tamaño
    stroke = 1.5 # Grosor del borde (opcional)
  ) +
  theme_minimal() +
  labs(title = glue::glue("{stringr::str_to_title(cabeceras$LOCALIDAD_.1)}"))

entidad <- st_read("/workdir/data/26 SONORA/ENTIDAD.shp")
el_mapita <- ggplot() +
  geom_sf(data = entidad) +
  geom_sf(data = municipios, fill = "black") +
  theme_void()

mapa_final <- cowplot::ggdraw() +
  cowplot::draw_plot(map_municipy) +
  cowplot::draw_plot(
    el_mapita,
    x = 0.05, y = 0.55, # Posición del inset (ajusta según necesidad)
    width = 0.3, height = 0.3 # Tamaño del inset
  )

ggsave(municipy_map, plot = mapa_final)
