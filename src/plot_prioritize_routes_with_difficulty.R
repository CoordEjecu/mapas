library(ggplot2)

from_municipy <- "mocte"
municipy_name <- list("hillo" = "Hermosillo", "guay" = "Guaymas", "mocte" = "Moctezuma")[[from_municipy]]
is_from_municipy <- rlang::sym(glue::glue("better_from_{from_municipy}"))

time_and_distance_cumsum <- readr::read_csv("/workdir/results/prioritized_routes.csv", show_col_types = FALSE)

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
  ggtitle("Prioritización de municipio por recursos y personas faltantes", subtitle = glue::glue("Desde {municipy_name}")) +
  theme_classic()
ggsave("/workdir/results/priorization_pareto.png")
