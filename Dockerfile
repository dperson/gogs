FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install gogs
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export version='0.10rc' && \
    export sha256sum='107105457f4bbdbb746449d2cf86a122785442173faca62eb01a' && \
    { mkdir -p /opt/gogs/custom/conf /opt/gogs/repositories || :; } && \
    groupadd -r gogs && \
    useradd -c 'Gogs' -d /opt/gogs/home -g gogs -m -r gogs && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl dropbear \
                git openssh-client procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    for i in dss rsa ecdsa; do rm -f /etc/dropbear/dropbear_${i}_host_key || :;\
                done && \
    echo "downloading: linux_amd64.tar.gz" && \
    curl -LOsC- "https://cdn.gogs.io/0.${version}/linux_amd64.tar.gz" && \
    sha256sum linux_amd64.tar.gz | grep -q "$sha256sum" && \
    (cd /opt; tar xf /linux_amd64.tar.gz) && \
    /bin/echo -e 'RUN_MODE = prod\nRUN_USER = gogs\n\n[repository]' \
                >/opt/gogs/custom/conf/app.ini && \
    /bin/echo -e 'ROOT = /opt/gogs/repositories\n' \
                >>/opt/gogs/custom/conf/app.ini && \
    /bin/echo -e '[server]\nSSH_PORT = 2222\n' \
                >>/opt/gogs/custom/conf/app.ini && \
    /bin/echo -e '[database]\n; Either "mysql", "postgres", or "sqlite3"' \
                >>/opt/gogs/custom/conf/app.ini && \
    /bin/echo -e 'DB_TYPE = sqlite3\nPATH = data/gogs.db' \
                >>/opt/gogs/custom/conf/app.ini && \
    chown -Rh gogs. /opt/gogs && \
    apt-get purge -qqy ca-certificates curl && \
    apt-get autoremove -qqy && apt-get clean -qqy && \
    rm -rf /tmp/* /var/lib/apt/lists/* linux_amd64.tar.gz
COPY gogs.sh /usr/bin/

EXPOSE 2222 3000

VOLUME ["/etc/dropbear", "/opt/gogs/home", "/opt/gogs/custom", \
            "/opt/gogs/data", "/opt/gogs/log", "/opt/gogs/repositories"]

ENTRYPOINT ["gogs.sh"]