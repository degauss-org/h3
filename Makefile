.PHONY: build test shell clean

build:
	docker build -t h3 .

test:
	docker run --rm -v "${PWD}/test":/tmp h3 my_address_file_geocoded.csv
	docker run --rm -v "${PWD}/test":/tmp h3 my_address_file_geocoded.csv 7
	docker run --rm -v "${PWD}/test":/tmp h3 my_address_file_geocoded.csv 3
	docker run --rm -v "${PWD}/test":/tmp h3 my_address_file_geocoded.csv sh

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp h3

clean:
	docker system prune -f
