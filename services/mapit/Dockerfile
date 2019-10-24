FROM python:2.7-alpine3.10

RUN apk add --no-cache tzdata \
        curl \
        git \
        gettext \
        postgresql-client \
        python \
        bash

RUN apk add --virtual .build-deps --no-cache --upgrade $PACKAGES \
   	&& echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
   	&& echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
   	&& echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories  \
    && apk add \
        gdal-dev \
        geos-dev

RUN apk add --no-cache \
        gcc \
        libc-dev \
        && pip install shapely

RUN apk update && \
    apk add --virtual build-deps python-dev musl-dev && \
    apk add postgresql-dev

RUN git clone https://github.com/alphagov/mapit.git

WORKDIR /mapit

RUN pip install psycopg2

RUN pip install --upgrade pip wheel setuptools
RUN pip install -r requirements.txt