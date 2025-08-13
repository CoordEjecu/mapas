all: check coverage

.PHONY: \
    check \
    clean \
    coverage \
    format \
    init \
    install \
    setup \
    tests

results/avance_de_brigadeo.png: src/firstmap.R data/municipio_meta_avance.csv
	mkdir --parents $(@D)
	Rscript src/firstmap.R

results/priorization_pareto.png: \
    src/prioritize_routes_with_difficulty.R \
    data/municipio_meta_avance.csv \
    data/votes_by_municipalities.csv \
    data/better_from_hillo.csv
	mkdir --parents $(@D)
	./runRscript src/prioritize_routes_with_difficulty.R

data/municipio_meta_avance.csv: src/clean_afiliados_by_sections.R data/REPORTE_AFILIACION_04_X_SECCION_20250813.csv
	./runRscript src/clean_afiliados_by_sections.R

data/votes_by_municipalities.csv: \
    src/add_votes_to_sections.R \
    data/summary_morena_2024.csv \
    data/secciones.csv
	./runRscript src/add_votes_to_sections.R

data/better_from_hillo.csv: \
    src/resource_radios.R \
    data/REPORTE_AFILIACION_04_MUN.csv \
    data/distancias_desde_guaymas.csv \
    data/distancias_desde_moctezuma.csv
	./runRscript src/resource_radios.R

check:
	R -e "library(styler)" \
      -e "resumen <- style_dir('R')" \
      -e "resumen <- rbind(resumen, style_dir('tests'))" \
      -e "resumen <- rbind(resumen, style_dir('tests/testthat'))" \
      -e "any(resumen[[2]])" \
      | grep FALSE

clean:
	rm --force *.tar.gz
	rm --force --recursive results
	rm --force --recursive tests/testthat/_snaps
	rm --force NAMESPACE
	rm --force data/better_from_hillo.csv
	rm --force data/municipio_meta_avance.csv
	rm --force data/votes_by_municipalities.csv

coverage: setup tests
	Rscript tests/testthat/coverage.R

format:
	R -e "library(styler)" \
      -e "style_dir('R')" \
      -e "style_dir('src')" \
      -e "style_dir('tests')" \
      -e "style_dir('tests/testthat')"

init: setup tests

setup: clean install

install:
	R -e "devtools::document()" && \
    R CMD build . && \
    R CMD check mapas_0.0.1.tar.gz && \
    R CMD INSTALL mapas_0.0.1.tar.gz

tests:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"

