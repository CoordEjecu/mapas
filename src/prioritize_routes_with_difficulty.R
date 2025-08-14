from_municipy <- "mocte"
municipy_name <- list("hillo" = "Hermosillo", "guay" = "Guaymas", "mocte" = "Moctezuma")[[from_municipy]]
is_from_municipy <- rlang::sym(glue::glue("better_from_{from_municipy}"))

better_from_hillo <- readr::read_csv("/workdir/data/better_from_hillo.csv", show_col_types = FALSE) |>
  dplyr::select(MUNICIPIO, better_from_hillo, better_from_mocte)

meta_avance <- readr::read_csv("/workdir/data/municipio_meta_avance.csv", show_col_types = FALSE)
votos <- readr::read_csv("/workdir/data/votes_by_municipalities.csv", show_col_types = FALSE)
time_distance <- readr::read_csv("/workdir/data/time_and_distance.csv", show_col_types = FALSE) |>
  dplyr::left_join(meta_avance, by = "MUNICIPIO") |>
  dplyr::left_join(votos, by = c("MUNICIPIO" = "NOMBRE_MUNICIPIO"))

time_and_distance <- time_distance |>
  dplyr::mutate(
    faltantes = (meta - avance) * percentage_morena,
    recursos = distancia + tiempo,
    pendiente = faltantes / recursos
  ) |>
  dplyr::left_join(better_from_hillo, by = c("MUNICIPIO"))

time_and_distance_cumsum <- time_and_distance |>
  dplyr::filter(faltantes > 0) |>
  dplyr::filter(!!is_from_municipy) |>
  dplyr::arrange(desc(pendiente)) |>
  dplyr::mutate(
    Acum_Personas = cumsum(faltantes) / sum(faltantes),
    Acum_Recursos = cumsum(recursos) / sum(recursos)
  ) |>
  dplyr::mutate(porcentaje = round(porcentaje, 1)) |>
  readdp::write_csv(glue::glue("/workdir/results/prioritized_routes.csv"))
