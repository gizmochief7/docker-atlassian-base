FROM buildpack-deps:jessie-curl
MAINTAINER Jonathon Leight <jonathon.leight@jleight.com>

ENV JAVA_BASEURL http://download.oracle.com/otn-pub/java/jdk/8u60-b27/
ENV JAVA_PACKAGE jre-8u60-linux-x64.tar.gz
ENV JAVA_VERSION jre1.8.0_60
ENV JAVA_URL     ${JAVA_BASEURL}/${JAVA_PACKAGE}
ENV JAVA_COOKIE  oraclelicense=accept-securebackup-cookie
ENV JAVA_HOME    /opt/jre/${JAVA_VERSION}
ENV JAVA_EXE     ${JAVA_HOME}/bin/java

ENV ATL_USER     atlassian
ENV ATL_HOME     /opt/atlassian
ENV ATL_DATA     /var/opt/atlassian
ENV ATL_BASEURL  http://www.atlassian.com/software

RUN set -x \
  && mkdir -p /opt/jre \
  && curl -kLb ${JAVA_COOKIE} ${JAVA_URL} | tar -xz -C /opt/jre \
  && update-alternatives --install /usr/bin/java java ${JAVA_EXE} 100 \
  && apt-get update \
  && apt-get install -y libtcnative-1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && groupadd -r "${ATL_USER}" \
  && useradd -r -g "${ATL_USER}" "${ATL_USER}" \
  && mkdir -p "${ATL_DATA}" \
  && chown "${ATL_USER}":"${ATL_USER}" "${ATL_DATA}" \
  && mkdir -p "${ATL_HOME}" \
  && chown "${ATL_USER}":"${ATL_USER}" "${ATL_HOME}"

USER "${ATL_USER}":"${ATL_USER}"
WORKDIR "${ATL_DATA}"
VOLUME ["${ATL_DATA}"]
