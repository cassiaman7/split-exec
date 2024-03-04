# init project path
HOMEDIR := $(shell pwd)
OUTDIR  := $(HOMEDIR)/output
# init command params
GO      := $(shell which go)
GOPATH  := $(GO) env GOPATH
GOMOD   := $(GO) mod
GOBUILD := $(GO) build
GOTEST  := $(GO) test -gcflags="-N -l"
GOPKGS  := $$($(GO) list ./...| grep -vE "vendor")
# make, make all
all: prepare compile package

# set proxy env
set-env:
	$(GO) env -w GO111MODULE=on
	$(GOMOD) tidy
prepare: set-env

# make test, test your code
test: prepare test-case
test-case:
	$(GOTEST) -v -cover $(GOPKGS)

#make compile
compile: build
build:
	$(GOBUILD) -o $(HOMEDIR)/bin/split-exec $(HOMEDIR)/cmd/split-exec/main.go

# make package
package: package-bin
package-bin:
	mkdir -p $(OUTDIR)
	cp $(HOMEDIR)/bin/split-exec $(OUTDIR)/split-exec

# make clean
clean:
	$(GO) clean
	rm -rf $(OUTDIR)
	rm -rf $(HOMEDIR)/bin/*

# avoid filename conflict and speed up build
.PHONY: all prepare compile test package clean build

