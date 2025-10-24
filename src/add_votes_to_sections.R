sections <- readr::read_csv("/workdir/data/secciones.csv", show_col_types = FALSE) |>
  dplyr::filter(ENTIDAD == 26, DISTRITO == 4) |>
  dplyr::select(NOMBRE, SECCION) |>
  dplyr::distinct()

summary_morena <- readr::read_csv("/workdir/data/summary_morena_2024.csv", show_col_types = FALSE)

sections_with_votes <- sections |>
  dplyr::left_join(summary_morena, by = "SECCION") |>
  readr::write_csv("/workdir/data/sections_with_votes.csv")

votes_by_municipalities <- sections_with_votes |>
  dplyr::group_by(NOMBRE_MUNICIPIO) |>
  dplyr::summarize(
    total = sum(total, na.rm = TRUE),
    morena = sum(morena, na.rm = TRUE),
    .groups = "drop"
  ) |>
  dplyr::mutate(
    percentage_morena = morena / total * 100
  ) |>
  readdp::write_csv("/workdir/data/votes_by_municipalities.csv")
