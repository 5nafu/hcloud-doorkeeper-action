# Container image that runs your code
FROM debian:11-slim

COPY scripts/ /usr/local/bin/
RUN /usr/local/bin/install.sh

ENTRYPOINT ["create.sh"]
              