#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(sf))

doc <- "
      Usage:
      entrypoint.R <filename> [<resolution>]
      "

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')
if (is.null(opt$resolution)) opt$resolution <- 8

d <- dht::read_lat_lon_csv(opt$filename, nest_df = TRUE, sf_out = TRUE)

dht::check_for_column(d$raw_data, "lat", d$raw_data$lat)
dht::check_for_column(d$raw_data, "lon", d$raw_data$lon)

d$d$h3 <- h3::geo_to_h3(d$d, res = opt$resolution)

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(
  d = d$d,
  raw_data = d$raw_data,
  filename = opt$filename,
  argument = paste0("res", opt$resolution)
)
