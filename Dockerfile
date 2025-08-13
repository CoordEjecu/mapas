FROM rocker/geospatial
COPY . /workdir
RUN Rscript -e "install.packages(c('cowplot', 'jsonlite', 'styler'), repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages(c('frictionless'), repos='http://cran.rstudio.com')"
RUN Rscript -e "remotes::install_github('niesfutbol/readdp', dependencies = TRUE, upgrade = 'always')"
WORKDIR /workdir
