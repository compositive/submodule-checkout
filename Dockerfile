FROM alpine/git

COPY github.sig /github.sig
COPY entrypoint.sh /entrypoint.sh

RUN addgroup docker
RUN adduser -D -g '' runner docker
RUN mkdir -p /github/workspace  && chown runner:docker /github/workspace

WORKDIR /github/workspace
VOLUME /github/workspace

USER runner
ENV HOME=/home/runner

ENTRYPOINT ["/entrypoint.sh"]
