FROM java:8-jre
MAINTAINER Jonathon Leight <jonathon.leight@jleight.com>

ENV ATL_USER=atlassian \
  ATL_HOME=/opt/atlassian \
  ATL_DATA=/var/opt/atlassian \
  ATL_BASEURL=http://www.atlassian.com/software

RUN set -x \
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
