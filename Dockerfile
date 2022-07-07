FROM rocker/r-ver:4.1.3

# DeGAUSS container metadata
ENV degauss_name="h3"
ENV degauss_version="0.2.1"
ENV degauss_description="h3 hierarchical spatial index"
ENV degauss_argument="resolution [default: 8]"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

RUN R --quiet -e "install.packages('remotes', repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"

RUN R --quiet -e "remotes::install_github('rstudio/renv@0.15.4')"

WORKDIR /app

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libproj-dev \
    libgit2-dev \
    && apt-get clean

COPY renv.lock .

RUN R --quiet -e "renv::restore()"

COPY entrypoint.R .
COPY us_h3_3_population_20k_minimum_hex_ids.rds .

WORKDIR /tmp

ENTRYPOINT ["/app/entrypoint.R"]
