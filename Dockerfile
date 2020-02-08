FROM alpine/git

ENV HOME=/github/home

COPY github.sig /github.sig
COPY entrypoint.sh /entrypoint.sh

RUN addgroup docker
RUN adduser -D -g "" --home "$HOME" runner docker
RUN mkdir -p /github/workspace && chown runner:docker /github/workspace

VOLUME /github/workspace
USER runner

ENTRYPOINT ["/entrypoint.sh"]
