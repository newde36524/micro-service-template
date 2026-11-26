# VERSION

APP_NAME := client-api
goctl := $(shell go env GOPATH)/bin/goctl

.PHONY: api
api:
	$(goctl) api format --dir=./api
	$(goctl) api go -api ./api/client.api -dir ./ 
