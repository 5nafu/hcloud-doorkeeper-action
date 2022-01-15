# Container image that runs your code
FROM debian:11-slim

ARG TARGETOS 
ARG TARGETARCH

COPY scripts/ /usr/local/bin/
RUN /usr/local/bin/install.sh

ENTRYPOINT ["create.sh"]
              