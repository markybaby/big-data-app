FROM rocker/r-ver:4.3.2

# Install system dependencies for RMySQL
RUN apt-get update && apt-get install -y \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages('RMySQL', repos='https://cloud.r-project.org')"

# Copy R scripts into container
COPY r-scripts/ /app/
WORKDIR /app

# Default command: you can override this in docker-compose or GitHub Actions
CMD ["Rscript", "test.R"]
