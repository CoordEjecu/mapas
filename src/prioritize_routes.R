library(ggplot2)
better_from_hillo <- readr::read_csv("better_from_hillo.csv", show_col_types = FALSE) |>
  dplyr::select(MUNICIPIO, better_from_hillo)

time_and_distance <- time_and_distance |>
  dplyr::mutate(
    faltantes = meta - avance,
    recursos = distancia + tiempo,
    pendiente = faltantes / recursos
  ) |>
  dplyr::left_join(better_from_hillo, by = c("MUNICIPIO"))

time_and_distance_cumsum <- time_and_distance |>
  dplyr::filter(faltantes > 0) |>
  dplyr::filter(better_from_hillo) |>
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
  xlab("Acumulado de Recursos") +
  ylab("Acumulado de Personas") +
  ggtitle("Prioritización de municipio por recursos y personas faltantes") +
  theme_classic()
ggsave("priorization_pareto.png")
