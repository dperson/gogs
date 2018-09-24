FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install gogs
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export version='0.11.66' && \
    export shasum='af01103fa4da64811f9139cce221c2d88063cb5d41283df79278a82' && \
    { mkdir -p /opt/gogs/custom/conf /opt/gogs/repositories || :; } && \
    groupadd -r gogs && \
    useradd -c 'Gogs' -d /opt/gogs/home -g gogs -m -r gogs && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl dropbear \
                git openssh-client procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    for i in dss rsa ecdsa; do rm -f /etc/dropbear/dropbear_${i}_host_key || :;\
                done && \
    file="gogs_${version}_linux_amd64.tar.gz" && \
    echo "downloading: $file ..." && \
    curl -LOSs "https://cdn.gogs.io/$version/$file" && \
    sha256sum $file | grep -q "$shasum" || \
    { echo "expected $shasum, got $(sha256sum $file)"; exit 13; } && \
    (cd /opt; tar xf /$file) && \
    echo 'RUN_MODE = prod\nRUN_USER = gogs\n\n[repository]' \
                >/opt/gogs/custom/conf/app.ini && \
    echo 'ROOT = /opt/gogs/repositories\n' >>/opt/gogs/custom/conf/app.ini && \
    echo '[server]\nSSH_PORT = 2222\n' >>/opt/gogs/custom/conf/app.ini && \
    echo '[database]\n; Either "mysql", "postgres", or "sqlite3"' \
                >>/opt/gogs/custom/conf/app.ini && \
    echo 'DB_TYPE = sqlite3\nPATH = data/gogs.db' \
                >>/opt/gogs/custom/conf/app.ini && \
    chown -Rh gogs. /opt/gogs && \
    apt-get purge -qqy ca-certificates curl && \
    apt-get autoremove -qqy && apt-get clean -qqy && \
    rm -rf /tmp/* /var/lib/apt/lists/* $file
COPY gogs.sh /usr/bin/

EXPOSE 2222 3000

VOLUME ["/etc/dropbear", "/opt/gogs/home", "/opt/gogs/custom", \
            "/opt/gogs/data", "/opt/gogs/log", "/opt/gogs/repositories"]

ENTRYPOINT ["gogs.sh"]