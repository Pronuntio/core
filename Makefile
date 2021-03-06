SERVICE := pronuntio-server
PACKAGE := github.com/pronuntio/core
COMMITMSG := ${shell git log -1 --pretty=%B}
VERSION := ${shell git describe --tags --always}
COMMIT := ${shell git rev-parse HEAD}
BUILDTIME := ${shell date -u '+%Y-%m-%d_%H:%M:%S'}
LDFLAGS := -s -w -X '${PACKAGE}/version.Version=${VERSION}' \
					-X '${PACKAGE}/version.BuildTime=${BUILDTIME}' \
					-X '${PACKAGE}/version.Revision=${COMMIT}'
ifdef OSX
	TARGET_OS=darwin
else
	TARGET_OS=linux
endif

.PHONY: all build clean test docker

all: clean build test docker

dep:
	dep ensure -v --vendor-only

build:
	mkdir -p bin/
	CGO_ENABLED=0 GOOS=$(TARGET_OS) go build -ldflags "${LDFLAGS}" -a -o bin/${SERVICE} cmd/server/main.go

test:
	go test ./...

clean:
	rm -rf bin/

docker:
	docker build . -t pronuntio-server:$(VERSION)
	docker build scripts/pg -t pronuntio-db:$(VERSION)
