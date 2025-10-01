datos <- readr::read_csv(
  "/workdir/data/AYUNTAMIENTO_2021.csv",
  show_col_types = FALSE)

party_name <- "MOVIMIENTO CIUDADANO"
party <- datos |>
  dplyr::group_by(id_seccion) |>
  dplyr::summarize(
	partido = sum(!!rlang::sym(party_name)),
	nominal = sum(lista_nominal),
	total = sum(`total_votos`)) |>
  dplyr::mutate(
	porcentaje_votos = partido / nominal * 100,
	participacion_ciudadana = total / nominal * 100) |>
  dplyr::ungroup() |>
  dplyr::arrange(-total)

readr::write_csv(party, "/workdir/results/pre_processed/summary_mc_2021_sonora_iee.csv")
