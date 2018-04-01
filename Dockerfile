FROM debian:9
RUN apt-get update && \
    apt-get install -y build-essential ostree multistrap apt-transport-https devscripts vim
RUN apt-get update && apt-get install -y \
        attr \
        autoconf \
        automake \
        bison \
        ca-certificates \
        cpio \
        debhelper \
        dh-exec \
        docbook-xml \
        docbook-xsl \
        e2fslibs-dev \
        elfutils \
        fuse \
        gnupg \
        gobject-introspection \
        gtk-doc-tools \
        libarchive-dev \
        libattr1-dev \
        libcap-dev \
        libfuse-dev \
        libgirepository1.0-dev \
        libglib2.0-dev \
        libgpgme-dev \
        liblzma-dev \
        libmount-dev \
        libselinux1-dev \
        libsoup2.4-dev \
        libsystemd-dev \
        libtool \
        procps \
        python3 \
        python3-yaml \
        zlib1g-dev \
        xsltproc \
        libglib2.0-doc

COPY ostree-2018.2 /ostree-pkg
RUN cd /ostree-pkg && \
    debian/rules binary && \
    rm -rf /ostree-pkg
RUN mkdir -p /debs && \
    mv /*.deb /debs && \
    cd /debs && \
    dpkg-scanpackages . | gzip > Packages.gz && \
    dpkg-scansources . > Sources

VOLUME /work
VOLUME /ostree
COPY build-atomic-debian.sh /
ENTRYPOINT ["/bin/bash", "/build-atomic-debian.sh"]
