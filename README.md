# h3 <a href='https://degauss.org'><img src='https://github.com/degauss-org/degauss_hex_logo/raw/main/PNG/degauss_hex.png' align='right' height='138.5' /></a>

[![](https://img.shields.io/github/v/release/degauss-org/h3?color=469FC2&label=version&sort=semver)](https://github.com/degauss-org/h3/releases)
[![container build status](https://github.com/degauss-org/h3/workflows/build-deploy-release/badge.svg)](https://github.com/degauss-org/h3/actions/workflows/build-deploy-release.yaml)

## Using

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon`, then the [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands):

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/h3:0.2.1 my_address_file_geocoded.csv
```

will produce `my_address_file_geocoded_h3_res8_0.2.1.csv` with the added column:

- **`h3`**: a hierarchical geospatial index

### Optional Argument

- The [resolution](https://h3geo.org/docs/core-library/restable) of the assigned h3 grid cell (0 - 15) can be specified and defaults to 8 when not specified.

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/h3:0.2.1 my_address_file_geocoded.csv 7
```

- It is also possible to specify for the h3 **s**afe **h**arbor (`h3_sh`) geohash by specifying `sh` instead of a numeric resolution:

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/h3:0.2.1 my_address_file_geocoded.csv sh
```

## Geomarker Methods

- Find more details about `h3` here: [https://h3geo.org/docs/](https://h3geo.org/docs/)

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
