FROM rocker/geospatial
COPY . /workdir
RUN Rscript -e "install.packages(c('jsonlite', 'styler'), repos='http://cran.rstudio.com')"
