datos <- readr::read_csv(
  "/workdir/data/REPORTE_AFILIACION_04_X_SECCION_20250813.csv",
  show_col_types = FALSE,
  col_types = list(META = readr::col_integer(), AVANCE = readr::col_integer())
)

municipio <- datos |>
  dplyr::group_by(MUNICIPIO) |>
  dplyr::summarise(
    meta = sum(META, na.rm = TRUE),
    avance = sum(AVANCE, na.rm = TRUE),
    porcentaje = avance / meta * 100,
    .groups = "drop"
  ) |>
  readdp::write_csv("/workdir/data/municipio_meta_avance.csv")
