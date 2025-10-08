year <- 2024
path <- glue::glue("/workdir/data/AYUNTAMIENTO_{year}.csv")
datos <- readr::read_csv(
  path,
  show_col_types = FALSE
)

party_name <- "MOVIMIENTO_CIUDADANO"
party <- datos |>
  dplyr::group_by(seccion) |>
  dplyr::summarize(
    partido = sum(!!rlang::sym(party_name)),
    nominal = sum(lista_nominal),
    total = sum(`total_votos`)
  ) |>
  dplyr::mutate(
    porcentaje_votos = partido / nominal * 100,
    participacion_ciudadana = total / nominal * 100
  ) |>
  dplyr::ungroup() |>
  dplyr::arrange(-total)

output_path <- glue::glue("/workdir/results/pre_processed/summary_mc_{year}_sonora_iee.csv")
readr::write_csv(party, output_path)
