FROM rocker/shiny:latest

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libcairo2-dev \
  libsqlite3-dev \
  libmariadbd-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libcurl4-openssl-dev \
  libssl-dev 

WORKDIR primace
COPY . .

RUN Rscript -e 'install.packages("renv", repos = "https://rstudio.r-universe.dev")'
RUN Rscript -e 'library(renv)' 
RUN Rscript -e 'renv::restore()'
RUN Rscript -e 'remotes::install_github("mlr-org/mlr3viz")'
RUN R CMD build .
RUN R CMD INSTALL primace_0.0.0.9000.tar.gz
RUN R -e 'library(primace)'

EXPOSE 3838

CMD ["Rscript", "-e", "primace::primace_init()"]
