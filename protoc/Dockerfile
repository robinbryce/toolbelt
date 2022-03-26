#syntax=docker/dockerfile:1.2
ARG GO_VERSION=1.17.7
ARG OS_VERSION=bullseye
FROM golang:${GO_VERSION}-${OS_VERSION}

ARG DESTDIR=/opt/protoc
ENV DESTDIR=${DESTDIR}

ENV GRPC_GATEWAY_VERSION=2.7.3
ENV PROTOC_GEN_GO_VERSION=1.27.1
ENV PROTOC_GEN_GO_GRPC_VERSION=1.2.0
ENV PROTOC_GEN_DOC_VERSION=1.5.0
ENV PROTOC_GEN_VALIDATE_VERSION=0.6.2
ENV PROTOC_VERSION=3.13.0
ENV GOOGLE_COMMON_PROTOS_VERSION=1.50.0

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip

WORKDIR $DESTDIR
# protoc command
RUN mkdir -p $DESTDIR \
  && curl -fsSOL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip \
  && unzip -q -o protoc-${PROTOC_VERSION}-linux-x86_64.zip -d $DESTDIR bin/protoc \
  && chmod +x $DESTDIR/bin/protoc \
  && unzip -q -o protoc-${PROTOC_VERSION}-linux-x86_64.zip -d $DESTDIR include/* \
  && chmod -R +rx $DESTDIR/include \
  && rm -rf protoc-${PROTOC_VERSION}-linux-x86_64.zip \
# Download common google api proto files.
  && curl -fsSOL https://github.com/googleapis/api-common-protos/archive/refs/tags/${GOOGLE_COMMON_PROTOS_VERSION}.tar.gz \
  && tar -C $DESTDIR -xvzf ${GOOGLE_COMMON_PROTOS_VERSION}.tar.gz \
  && rm -rf $DESTDIR/usr/local/api-common-protos-master \
  && mv $DESTDIR/api-common-protos-${GOOGLE_COMMON_PROTOS_VERSION} $DESTDIR/api-common-protos-master \
  && rm -f ${GOOGLE_COMMON_PROTOS_VERSION}.tar.gz \
  && curl -fsSOL https://raw.githubusercontent.com/grpc/grpc-proto/master/grpc/health/v1/health.proto \
  && mkdir -p $DESTDIR/api-common-protos-master/grpc/health/v1

RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v${GRPC_GATEWAY_VERSION} \
  && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v${GRPC_GATEWAY_VERSION} \
  && go install google.golang.org/protobuf/cmd/protoc-gen-go@v${PROTOC_GEN_GO_VERSION} \
  && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v${PROTOC_GEN_GO_GRPC_VERSION} \
# Additional proto utilities
  && go install github.com/envoyproxy/protoc-gen-validate@v${PROTOC_GEN_VALIDATE_VERSION} \
  && go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v${PROTOC_GEN_DOC_VERSION}

ENV PROTO_GEN_GO_INC=/go/pkg/mod/google.golang.org/protobuf@v${PROTOC_GEN_GO_VERSION}/cmd/protoc-gen-go
ENV GRPC_GATEWAY_INC=/go/pkg/mod/github.com/grpc-ecosystem/grpc-gateway/v2@v${GRPC_GATEWAY_VERSION}/runtime
ENV ENVOY_VALIDATE_INC=/go/pkg/mod/github.com/envoyproxy/protoc-gen-validate@v${PROTOC_GEN_VALIDATE_VERSION}
ENV GOPKG_OVERRIDES=",Mgoogle/protobuf/field_mask.proto=google.golang.org/genproto/protobuf/field_mask"

RUN \
    chmod a+x $DESTDIR/bin/* \
    && chmod -R a+rw /go
ENV PATH=$DESTDIR/bin:$PATH
ENTRYPOINT [ "protoc" ]
