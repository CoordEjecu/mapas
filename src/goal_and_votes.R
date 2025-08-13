votes_by_municipalities <- readr::read_csv("/workdir/data/votes_by_municipalities.csv", show_col_types = FALSE)
goals <- readr::read_csv("/workdir/data/municipio_meta_avance.csv", show_col_types = FALSE)

goals_and_votes <- votes_by_municipalities |>
  dplyr::left_join(goals, by = c("NOMBRE_MUNICIPIO" = "MUNICIPIO")) |>
  dplyr::select(NOMBRE_MUNICIPIO, total, morena, meta, avance) |>
  readr::write_csv("/workdir/results/goals_and_votes.csv")
