#syntax=docker/dockerfile:1.2
FROM debian:bullseye-slim
ARG DESTDIR=/opt/protoc
ENV DESTDIR=${DESTDIR}

ENV GRPC_GATEWAY_VERSION=2.7.3
ENV PROTOC_GEN_GO_VERSION=1.27.1
ENV PROTOC_GEN_GO_GRPC_VERSION=1.2.0
ENV PROTOC_GEN_DOC_VERSION=v1.5.0
ENV PROTOC_GEN_VALIDATE_VERSION=v0.6.2
ENV GRPC_HEALTH_PROBE_VERSION=v0.3.5
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

ENV PATH=$DESTDIR/bin:$PATH
ENTRYPOINT [ "protoc" ]
