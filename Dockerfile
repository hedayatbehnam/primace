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

COPY /R ./R
COPY renv.lock ./renv.lock
COPY app.R ./app.R
COPY .Rprofile ./.Rprofile
COPY .Renviron ./.Renviron
COPY DESCRIPTION ./DESCRIPTION
COPY NAMESPACE ./NAMESPACE
COPY primace.Rproj ./primace.Rproj
COPY .Rbuildignore ./Rbuildignore
COPY renv ./renv

RUN Rscript -e 'install.packages("renv", repos = "https://rstudio.r-universe.dev")' 
RUN Rscript -e 'library(renv)' 
RUN Rscript -e 'renv::restore()'
RUN R CMD build ./R

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp(host = '0.0.0.0', port = 3838)"]
