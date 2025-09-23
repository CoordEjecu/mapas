all_votes <- readr::read_csv("/workdir/data/Computos2024-Diputado.csv", show_col_types = FALSE) |>
  dplyr::filter(ID_ENTIDAD == 26, ID_DISTRITO_FEDERAL == 4)

cleaned_all_votes <- all_votes |>
  dplyr::mutate(
    TOTAL_PERSONAS_VOTARON = as.numeric(TOTAL_PERSONAS_VOTARON),
    MORENA = as.numeric(MORENA)
  )
cleaned_all_votes |>
  dplyr::group_by(SECCION) |>
  dplyr::summarize(
    total = sum(TOTAL_PERSONAS_VOTARON, na.rm = T),
    morena = sum(MORENA, na.rm = T)
  ) |>
  readr::write_csv("/workdir/data/summary_morena_2024.csv")
