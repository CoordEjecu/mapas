FROM rocker/geospatial
COPY . /workdir
RUN Rscript -e "install.packages(c('styler'), repos='http://cran.rstudio.com')"
