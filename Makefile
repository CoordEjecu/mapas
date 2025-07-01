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

avance_de_brigadeo.png: src/firstmap.R data/REPORTE_AFILIACION_04_MUN.csv
	Rscript src/firstmap.R

check:
	R -e "library(styler)" \
      -e "resumen <- style_dir('R')" \
      -e "resumen <- rbind(resumen, style_dir('tests'))" \
      -e "resumen <- rbind(resumen, style_dir('tests/testthat'))" \
      -e "any(resumen[[2]])" \
      | grep FALSE

clean:
	rm --force *.tar.gz
	rm --force --recursive tests/testthat/_snaps
	rm --force NAMESPACE

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
