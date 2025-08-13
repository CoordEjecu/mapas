add_resources <- function(distances_and_times) {
  distances_and_times |>
    dplyr::mutate(
      recursos = distancia + tiempo,
    )
}

select_municipy_and_resource <- function(distances_and_times) {
  distances_and_times |>
    dplyr::select(c(MUNICIPIO, recursos))
}

time_and_distance_hillo <- readr::read_csv("/workdir/data/REPORTE_AFILIACION_04_MUN.csv", show_col_types = FALSE) |>
  dplyr::filter(!is.na(No.)) |>
  add_resources() |>
  select_municipy_and_resource()

time_and_distance_guaymas <- readr::read_csv("/workdir/data/distancias_desde_guaymas.csv", show_col_types = FALSE) |>
  add_resources() |>
  select_municipy_and_resource()

time_and_distance_moctezuma <- readr::read_csv("/workdir/data/distancias_desde_moctezuma.csv", show_col_types = FALSE) |>
  add_resources() |>
  select_municipy_and_resource()

to_compare_resource <- time_and_distance_hillo |>
  dplyr::left_join(time_and_distance_guaymas, by = c("MUNICIPIO"), suffix = c("_hillo", "_guay")) |>
  dplyr::left_join(time_and_distance_moctezuma, by = c("MUNICIPIO")) |>
  dplyr::mutate(
    diff_guaymas_hillo = recursos_guay - recursos_hillo,
    diff_mocte_hillo = recursos - recursos_hillo,
    diff_guaymas_mocte = recursos_guay - recursos,
    better_from_hillo = ifelse((diff_guaymas_hillo > -120) & (diff_mocte_hillo > -240), TRUE, FALSE),
    better_from_mocte = ifelse(!(diff_mocte_hillo > -120) & (diff_guaymas_mocte > -440), TRUE, FALSE)
  ) |>
  readdp::write_csv("/workdir/data/better_from_hillo.csv")
