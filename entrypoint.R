#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(sf))
withr::with_message_sink("/dev/null", library(dplyr))
withr::with_message_sink("/dev/null", library(tidyr))

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

if (!opt$resolution %in% c(1:15, "sh")) {
  cli::cli_abort("The resolution argument must be a number between 1 and 15 or {.code sh}")
}

if (opt$resolution == "sh") {
  h3_sh_key <- local({
    h3_sh <- readRDS("/app/us_h3_3_population_20k_minimum_hex_ids.rds")
    h3_sh_key <- tibble::tibble(h3_sh = h3_sh) %>%
      dplyr::mutate(h3_sh_split = strsplit(h3_sh, "-")) %>%
      tidyr::unnest(h3_sh_split)
    h3_sh_key
  })
  d$d$h3 <- h3::geo_to_h3(d$d, res = 3)
  d$d <- left_join(d$d, h3_sh_key, by = c("h3" = "h3_sh_split"))
} else {
  d$d$h3 <- h3::geo_to_h3(d$d, res = as.numeric(opt$resolution))
}

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(
  d = d$d,
  raw_data = d$raw_data,
  filename = opt$filename,
  argument = paste0("res_", opt$resolution)
)
