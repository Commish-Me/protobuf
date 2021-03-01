APIS_WITH_PROTOS = $(filter-out third_party, $(sort $(wildcard */*.proto)))

DATETIME := "unknown"

ifeq ($(OS),Windows_NT)
	DATETIME := $(shell echo %date:~10,4%-%date:~4,2%-%date:~7,2%t%time:~0,2%h%time:~3,2%m)
else
	DATETIME := $(shell bash -c "date +%Y-%m-%dt%T")
endif

generate:
	protoc \
		--proto_path=. \
		--proto_path=third_party \
		--proto_path=$(GOPATH)/src/github.com/protocolbuffers/protobuf/src \
		--descriptor_set_out=descriptor.pb \
		--go_out=plugins=grpc:$(GOPATH)/src \
		$(APIS_WITH_PROTOS)

deploy: generate
	gcloud api-gateway api-configs create $(DATETIME) \
		--api=api --project=commish-me \
		--grpc-files=descriptor.pb,config.yaml

	gcloud api-gateway gateways update us-central1 \
  		--api=api --api-config=$(DATETIME) \
		--location=us-central1