FROM rocker/r-ver:4.3.2

# Install system dependencies for RMySQL
RUN apt-get update && apt-get install -y curl\
    libmysqlclient-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('DBI', 'RMySQL', 'httpuv', 'dplyr'), repos='https://cloud.r-project.org')"

# Copy R scripts into container
COPY r-scripts/ /app/r-scripts/
WORKDIR /app

# Default command: you can override this in docker-compose or GitHub Actions
CMD ["Rscript", "test.R"]
