# deepnox/python-ta-lib:0.4.24_python3.10-alpine3.16
# ===================================================

FROM python:3.11.4-alpine3.17

MAINTAINER The Deepnox Team <contact@deepnox.io>

ENV PYTHON_TA_LIB_VERSION "0.4.26"

USER "root"
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

WORKDIR "/root"

CMD ["python3"]
