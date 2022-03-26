#!/bin/sh
export GOCACHE=$PWD/go-cache
export GOMODCACHE=$PWD/go-mod/cache
mkdir -p $GOCACHE
mkdir -p $GOMODCACHE
export PROTO_GEN_GO_INC=$(go list -f "{{.Dir}}" google.golang.org/protobuf/cmd/protoc-gen-go)
export GRPC_GATEWAY_INC=$(go list -f "{{.Dir}}" github.com/grpc-ecosystem/grpc-gateway/v2/runtime)
export ENVOY_VALIDATE_INC=$(go list -f "{{".Dir"}}" github.com/envoyproxy/protoc-gen-validate)
export PROTO_INC="-I ${PROTO_GEN_GO_DIR} -I ${GRPC_GATEWAY_DIR} -I $ENVOY_VALIDATE_DIR -I $API_COMMON_DIR"
echo $PROTO_INC
protoc \
  -I ${PROTO_GEN_GO_DIR} \
  -I ${GRPC_GATEWAY_DIR} \
  -I $ENVOY_VALIDATE_DIR \
  -I $API_COMMON_DIR \
  $@

