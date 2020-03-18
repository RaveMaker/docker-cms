FROM python:3.7-alpine

# Fix Alpine repositories http to https
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories

# Install Alpine packages
RUN apk add --no-cache git postgresql-dev bash alpine-sdk libffi-dev cups-dev libpq libcap-dev asciidoc ncurses

# Make sure directories exist
RUN mkdir -p /var/local/cache/cms && \
    mkdir -p /config && \
    mkdir -p /usr/local/etc

# Create "cmsuser" group
RUN addgroup -S cmsuser || true

# Download CMS and install dependencies
RUN git clone https://github.com/cms-dev/cms --recursive /cms

# Import con_test
RUN git clone https://github.com/cms-dev/con_test /cms/con_test

WORKDIR /cms

RUN curl -L https://github.com/cms-dev/cms/pull/1143.diff | patch -p1 || true
RUN python3 -m ensurepip
RUN python3 -m pip install -r requirements.txt

# Install CMS
RUN python3 setup.py build
RUN python3 setup.py install

# Fix Isolate warning
RUN sed -i 's/sys\/signal.h/signal.h/g' /cms/isolate/isolate.c

# Make Isolate bin
WORKDIR /cms/isolate
RUN make all
RUN ln -s /cms/isolate/isolate /usr/bin/isolate

WORKDIR /
RUN mv /cms /cms-dev
VOLUME /cms

COPY entrypoint.sh /

# 8888 - CMS, 8889 - Admin
EXPOSE 8888 8889

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cms"]
