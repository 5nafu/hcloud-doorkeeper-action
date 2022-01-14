# Container image that runs your code
FROM boky/hcloud AS hcloud
FROM alpine:3.10

COPY --from=hcloud /hcloud /usr/local/bin/hcloud

COPY create.sh /create.sh
RUN ln -s /create.sh /delete.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/create.sh"]
              