#syntax=docker/dockerfile:1.2
FROM debian:bullseye-slim
ARG DESTDIR=/opt/flatc
ENV DESTDIR=${DESTDIR}

COPY --from=neomantra/flatbuffers /usr/local/bin/flatc $DESTDIR/bin/flatc
COPY --from=neomantra/flatbuffers /usr/local/include/flatbuffers $DESTDIR/include/flatbuffers
COPY --from=neomantra/flatbuffers /usr/local/lib/libflatbuffers.a $DESTDIR/lib/libflatbuffers.a
COPY --from=neomantra/flatbuffers /usr/local/lib/cmake/flatbuffers $DESTDIR/lib/cmake/flatbuffers


COPY --from=neomantra/flatbuffers /usr/local/bin/flatcc $DESTDIR/bin/flatcc
COPY --from=neomantra/flatbuffers /usr/local/include/flatcc $DESTDIR/include/flatcc
COPY --from=neomantra/flatbuffers /usr/local/lib/libflatcc.a /usr/local/lib/libflatccrt.a $DESTDIR/lib/

ENV PATH=$DESTDIR/bin:$PATH
ENTRYPOINT [ "flatc" ]
