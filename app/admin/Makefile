# VERSION

APP_NAME := admin-api
goctl := $(shell go env GOPATH)/bin/goctl

.PHONY: api
api:
	$(goctl) api format --dir=./api
	$(goctl) api go -api ./api/admin.api -dir ./ 
