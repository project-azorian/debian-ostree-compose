FROM debian:9
RUN apt-get update && \
    apt-get install -y ostree multistrap apt-transport-https jq
VOLUME /work
VOLUME /ostree
COPY build-atomic-debian.sh /
ENTRYPOINT ["/bin/bash", "/build-atomic-debian.sh"]
