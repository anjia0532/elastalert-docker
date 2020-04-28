FROM python:3.6-alpine


LABEL description="ElastAlert for docker"
LABEL maintainer="anjia0532 (anjia0532@gmail.com)"

ARG ELASTALERT_VERSION=v0.2.4
ARG MIRROR=false
ARG ALPINE_HOST="mirrors.aliyun.com"

ENV SET_CONTAINER_TIMEZONE true 
ENV CONTAINER_TIMEZONE UTC
ENV TZ "${CONTAINER_TIMEZONE}"

ENV ELASTALERT_URL https://github.com/Yelp/elastalert/archive/${ELASTALERT_VERSION}.tar.gz  

ENV ELASTICSEARCH_HOST http://es-hot 
ENV ELASTICSEARCH_PORT 9200 
ENV ELASTICSEARCH_USERNAME "" 
ENV ELASTICSEARCH_PASSWORD ""

ENV ELASTALERT_HOME /opt/elastalert 
ENV RULES_DIRECTORY /opt/elastalert/rules 
ENV ELASTALERT_PLUGIN_DIRECTORY /opt/elastalert/elastalert_modules 


WORKDIR /opt/elastalert

COPY ./pydistutils.cfg /tmp/.pydistutils.cfg
COPY ./pip.conf /tmp/pip.conf

RUN \
    if $MIRROR; then sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_HOST}/g" /etc/apk/repositories ; mkdir -p ~/.pip/; cp /tmp/pip.conf ~/.pip/pip.conf ; cp /tmp/.pydistutils.cfg ~/.pydistutils.cfg ; fi && \

    apk --update --no-cache add gcc bash curl python-dev tzdata  libmagic tar musl-dev linux-headers g++ libffi-dev libffi openssl-dev gettext libintl && \
    
    mkdir -p ${ELASTALERT_PLUGIN_DIRECTORY} && \
    mkdir -p ${RULES_DIRECTORY} && \
    
    curl -Lo elastalert.tar.gz ${ELASTALERT_URL} && \
    tar -xzvf elastalert.tar.gz -C ${ELASTALERT_HOME} --strip-components 1 && \
    rm elastalert.tar.gz && \
    cd ${ELASTALERT_HOME}  &&\
    #pip install "requests==2.18.1" &&\
    #pip install "setuptools>=11.3" && \
    python setup.py install


COPY ./start-elastalert.sh /opt/start-elastalert.sh
RUN chmod +x /opt/start-elastalert.sh

COPY ./rules/* ${RULES_DIRECTORY}/
COPY ./elastalert_modules/* ${ELASTALERT_PLUGIN_DIRECTORY}/

# Launch Elastalert when a container is started.
CMD ["/opt/start-elastalert.sh"]
