library(ggplot2)
time_and_distance <- readr::read_csv("/workdir/data/REPORTE_AFILIACION_04_MUN.csv", show_col_types = FALSE) |>
  dplyr::filter(!is.na(No.)) |>
  dplyr::mutate(
    faltantes = META - AVANCE,
    recursos = distancia + tiempo,
    pendiente = faltantes / recursos
  )

time_and_distance_cumsum <- time_and_distance |>
  dplyr::filter(faltantes > 0) |>
  dplyr::arrange(desc(pendiente)) |>
  dplyr::mutate(
    Acum_Personas = cumsum(faltantes) / sum(faltantes),
    Acum_Recursos = cumsum(recursos) / sum(recursos)
  )

time_and_distance_cumsum |>
  ggplot(aes(x = Acum_Recursos, y = Acum_Personas, label = rownames(MUNICIPIO))) +
  geom_point(size = 3, color = "firebrick") +
  geom_line() +
  geom_abline(slope = 1, linetype = "dashed") +
  geom_text(
    aes(label = MUNICIPIO), # Usa la columna MUNICIPIO como etiqueta
    hjust = 0.5, # Ajuste horizontal de la etiqueta
    vjust = -0.7, # Ajuste vertical
    size = 3,
    color = "black"
  ) +
  theme_classic()
ggsave("priorization_pareto.png")
