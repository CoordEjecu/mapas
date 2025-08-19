library(sf)

id_name <- jsonlite::fromJSON("tests/data/id_name_municipies.json")
municipio <- id_name$BACUM
cabeceras <- st_read("/workdir/data/26 SONORA/CABECERA_MUNICIPAL.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
secciones <- st_read("/workdir/data/26 SONORA/SECCION.shp") |>
  dplyr::filter(MUNICIPIO == municipio)
id_seccion <- secciones$SECCION

name_head_municipy <- cabeceras$LOCALIDAD_.1 |>
  stringr::str_replace_all(" ", "_") |>
  stringr::str_to_lower()
goals_and_affiliate <- readr::read_csv("/workdir/data/REPORTE_AFILIACION_04_X_SECCION.csv", show_col_types = FALSE) |>
  dplyr::select(c(4, 6:8))
sections_with_votes_path <- glue::glue("/workdir/results/sections_with_votes_{name_head_municipy}.csv")
sections_with_votes <- readr::read_csv("/workdir/data/sections_with_votes.csv", show_col_types = FALSE) |>
  dplyr::filter(SECCION %in% id_seccion) |>
  dplyr::left_join(goals_and_affiliate, by = c("SECCION" = "SECCION")) |>
  dplyr::relocate(nominal, .after = SECCION) |>
  readr::write_csv(sections_with_votes_path)

make_list_from_row <- function(row) {
  list(
    municipio = stringr::str_to_title(row$MUNICIPIO),
    distancia = row$distancia,
    tiempo = row$tiempo,
    meta = row$meta,
    avance = row$avance,
    municipy_path = name_head_municipy,
    all_sections = id_seccion
  )
}

time_and_distance_path <- glue::glue("/workdir/data/non-tabular/time_and_distance_{name_head_municipy}.json")
time_and_distance <- readr::read_csv("/workdir/data/time_and_distance.csv", show_col_types = FALSE)
goals_and_votes <- readr::read_csv("/workdir/data/goals_and_votes.csv", show_col_types = FALSE)
time_and_distance |>
  dplyr::left_join(goals_and_votes, by = c("MUNICIPIO" = "NOMBRE_MUNICIPIO")) |>
  dplyr::filter(MUNICIPIO == cabeceras$LOCALIDAD_.1) |>
  make_list_from_row() |>
  jsonlite::toJSON(pretty = T, force = TRUE, auto_unbox = TRUE) |>
  write(time_and_distance_path)
