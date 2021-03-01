apis = $(filter-out third_party, $(sort $(wildcard */*.proto)))

generate:
	protoc \
		--proto_path=. \
		--proto_path=third_party \
		--proto_path=$(GOPATH)/src/github.com/protocolbuffers/protobuf/src \
		--descriptor_set_out=descriptor.pb \
		--go_out=plugins=grpc:. --go_opt=paths=source_relative \
		$(apis)
		
	protoc \
		--proto_path=. \
		--proto_path=third_party \
		--proto_path=$(GOPATH)/src/github.com/protocolbuffers/protobuf/src \
		--descriptor_set_out=descriptor.pb \
		--go_out=plugins=grpc:$(GOPATH)/src \
		$(apis)