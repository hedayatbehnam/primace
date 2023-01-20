FROM rocker/shiny:latest
ARG GIT_PAT
ARG LIARA_ENDPOINT
ARG LIARA_BUCKET_NAME
ARG LIARA ACCESS_KEY
ARG LIARA_SECRET_KEY
ENV LIARA_ENDPOINT=${LIARA_ENDPOINT}
ENV LIARA_BUCKET_NAME=${LIARA_BUCKET_NAME}
ENV LIARA_ACCESS_KEY=${LIARA_ACCESS_KEY}
ENV LIARA_SECRET_KEY=${LIARA_SECRET_KEY}
ENV GITHUB_PAT=${GIT_PAT}
RUN echo "$GITHUB_PAT"
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libcairo2-dev \
  libsqlite3-dev \
  libmariadbd-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libcurl4-openssl-dev \
  libssl-dev \ 
  libharfbuzz-dev \
  libfribidi-dev \
  libfreetype6-dev \
  libpng-dev \
  libtiff5-dev \
  libjpeg-dev

WORKDIR primace
COPY . .

RUN Rscript -e 'install.packages("renv", repos = "https://rstudio.r-universe.dev")'
RUN Rscript -e 'library(renv)' 
RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'renv::settings$ignored.packages(c("mlr3viz","mlr3proba","mlr3learners","mlr3extralearners","mlr3","mlr3measures", "mlr3tuning", "mlr3misc"))'
RUN Rscript -e 'renv::restore(exclude=c("mlr3viz","mlr3proba","mlr3learners","mlr3extralearners","mlr3","mlr3measures", "mlr3tuning", "mlr3misc"))'
RUN Rscript -e 'install.packages("mlr3")'
RUN Rscript -e 'install.packages("mlr3learners")'
RUN Rscript -e 'install.packages("mlr3measures")'
RUN Rscript -e 'install.packages("mlr3tuning")'
RUN Rscript -e 'install.packages("mlr3misc")'
RUN Rscript -e 'devtools::install_github("mlr-org/mlr3extralearners")'
RUN Rscript -e 'devtools::install_github("mlr-org/mlr3proba")'
RUN Rscript -e 'devtools::install_version("mlr3viz", version = "0.5.10")'
RUN R CMD build .
RUN R CMD INSTALL primace_0.0.0.9000.tar.gz
RUN R -e 'library(primace)'

EXPOSE 3838

CMD ["Rscript", "-e", "primace::primace_init()"]
