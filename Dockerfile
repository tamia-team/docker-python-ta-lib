# deepnox/python-ta-lib:0.4.28_poetry1.6.1
# =========================================

FROM deepnox/python-poetry:1.6.1-python3.11.5-alpine3.18 as builder

MAINTAINER The Deepnox Team <contact@deepnox.io>

ENV PYTHON_TA_LIB_VERSION "0.4.28"

USER root
WORKDIR "/tmp"

RUN apk add --no-cache --virtual .build-deps \
        musl-dev \
        linux-headers \
        gcc \
        g++ \
        make \
        curl \
    && cd /tmp \
    && curl -L -O http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
    && tar -zxf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && pip3 install setuptools numpy \
    && pip3 install ta-lib==${PYTHON_TA_LIB_VERSION} \
    && apk del .build-deps \
    && rm -rf /root/.cache \
              /tmp/* \
              /var/cache/apk/* \
              /var/lib/apk/lists/*

FROM scratch 

COPY --from=builder ["/", "/"]

USER python
WORKDIR "/app"

CMD ["python3"]
