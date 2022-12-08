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

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

COPY /R ./R
COPY renv.lock ./renv.lock
COPY app.R ./app.R
COPY .Rprofile ./.Rprofile

RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::consent(provided=T)'
RUN Rscript -e 'renv::restore()'

EXPOSE 3000

CMD ["Rscript app.R"]
