get_name_from_standard_name <- function(schema, standard_name) {
schema$fields |>
  purrr::keep(~ .x$standard_name == standard_name) |>
  purrr::map_chr("name")
}