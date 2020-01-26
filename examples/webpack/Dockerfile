ARG NODE_VERSION=latest

FROM node:${NODE_VERSION}

ENV LANG C.UTF-8

RUN apt update \
  && apt install -y --no-install-recommends \
    build-essential \
  && apt -y clean \
  && rm -rf /var/lib/apt/lists/*

ENV ENTRYKIT_VERSION 0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

WORKDIR /usr/local/src

COPY . /usr/local/src

ENTRYPOINT [ \
  "prehook", "npm install", "--", \
  "prehook", "npm prune", "--" \
]
