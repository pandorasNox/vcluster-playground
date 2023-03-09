# read env vars
include .env
export

.PHONY: build
build:
	./tools.sh build

.PHONY: cli
cli:
	./tools.sh cli
