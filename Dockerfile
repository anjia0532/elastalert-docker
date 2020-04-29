FROM python:3.6-alpine

LABEL description="ElastAlert for docker reference @sc250024/docker-elastalert"
LABEL maintainer="anjia0532 (anjia0532@gmail.com) Scott Crooks <scott.crooks@gmail.com>"

ARG ELASTALERT_VERSION=v0.2.4
ARG MIRROR=false
ARG ALPINE_HOST="mirrors.aliyun.com"
ARG PIP_MIRROR="https://mirrors.aliyun.com/pypi/simple/"
ARG DOCKERIZE_VERSION=v0.6.1

ENV ELASTALERT_URL=https://github.com/Yelp/elastalert/archive/${ELASTALERT_VERSION}.tar.gz  \
    ELASTALERT_HOME=/opt/elastalert \
    ELASTALERT_RULES_DIRECTORY=${ELASTALERT_HOME}/rules \
    ELASTALERT_PLUGIN_DIRECTORY=${ELASTALERT_HOME}/elastalert_modules \
    SET_CONTAINER_TIMEZONE=true \
    CONTAINER_TIMEZONE=Etc/UTC \
    TZ="${CONTAINER_TIMEZONE}" 

ENV ELASTALERT_CONFIG="${ELASTALERT_HOME}/config.yaml" \
    ELASTALERT_INDEX=elastalert_status \
    ELASTALERT_SYSTEM_GROUP=elastalert \
    ELASTALERT_SYSTEM_USER=elastalert \
    ELASTICSEARCH_HOST=elasticsearch \
    ELASTICSEARCH_PORT=9200 \
    ELASTICSEARCH_USE_SSL=False \
    ELASTICSEARCH_VERIFY_CERTS=False


WORKDIR ${ELASTALERT_HOME}

# Create directories and Elastalert system user/group.
# The /var/empty directory is used by openntpd.
RUN mkdir -p "${ELASTALERT_HOME}" && \
    mkdir -p "${ELASTALERT_PLUGIN_DIRECTORY}" && \
    mkdir -p "${ELASTALERT_RULES_DIRECTORY}" && \
    mkdir -p /var/empty && \
    addgroup "${ELASTALERT_SYSTEM_GROUP}" && \
    adduser -S -G "${ELASTALERT_SYSTEM_GROUP}" "${ELASTALERT_SYSTEM_USER}" && \
    chown -R "${ELASTALERT_SYSTEM_USER}":"${ELASTALERT_SYSTEM_GROUP}" "${ELASTALERT_HOME}" "${ELASTALERT_PLUGIN_DIRECTORY}" "${ELASTALERT_RULES_DIRECTORY}"

# set up environment install packages
RUN set -ex && \
    if $MIRROR; then sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_HOST}/g" /etc/apk/repositories ; pip config set global.index-url ${PIP_MIRROR} ; /bin/echo -e [easy_install]\\nindex-url = ${PIP_MIRROR} >> ${ELASTALERT_HOME}/setup.cfg ; fi && \

    apk update && \
    apk upgrade && \
    apk add --no-cache \
        ca-certificates \
        tzdata \
        dumb-init \
        bash \
        openssl && \

    apk add --no-cache --virtual \
        .build-dependencies \
        gcc \ 
        libffi-dev \
        curl \
        python-dev \
        tar \
        musl-dev \
        openssl-dev && \
    pip install --upgrade pip

# Get Dockerize for configuration templating
RUN set -ex && \
    curl -Lo dockerize.tar.gz \
        "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" && \
    tar -C /usr/local/bin -xzvf dockerize.tar.gz && \
    chmod +x "/usr/local/bin/dockerize" && \
    rm dockerize.tar.gz

# compile elastalert
RUN set -ex && \
    curl -Lo elastalert.tar.gz ${ELASTALERT_URL} && \
    tar -xzvf elastalert.tar.gz -C ${ELASTALERT_HOME} --strip-components 1 && \
    rm elastalert.tar.gz && \
    cd ${ELASTALERT_HOME}  &&\
    python setup.py install && \
    apk del --purge .build-dependencies && \
    rm -rf /var/cache/apk/*


COPY ./rules/* ${ELASTALERT_RULES_DIRECTORY}/
COPY ./elastalert_modules/* ${ELASTALERT_PLUGIN_DIRECTORY}/

# Copy the ${ELASTALERT_HOME} template
COPY config.yaml.tpl "${ELASTALERT_HOME}/config.yaml.tpl"

# Copy the script used to launch the Elastalert when a container is started.
COPY docker-entrypoint.sh /opt/docker-elastalert.sh

RUN chmod +x /opt/docker-elastalert.sh

# The square brackets around the 'e' are intentional. They prevent `grep`
# itself from showing up in the process list and falsifying the results.
# See here: https://stackoverflow.com/questions/9375711/more-elegant-ps-aux-grep-v-grep
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD ps -ef | grep "[e]lastalert.elastalert" >/dev/null 2>&1

# Launch Elastalert when a container is started.
CMD ["/opt/docker-elastalert.sh"]
