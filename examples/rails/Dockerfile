ARG RUBY_VERSION=latest

FROM ruby:${RUBY_VERSION}

ENV LANG C.UTF-8

RUN apt update \
  && apt install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    openssl \
    sqlite3 \
  && apt -y clean \
  && rm -rf /var/lib/apt/lists/*

ENV ENTRYKIT_VERSION 0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

RUN mkdir -p /src
WORKDIR /src

RUN gem install bundler
RUN bundle config --global build.nokogiri --use-system-libraries

ENTRYPOINT [ \
  "prehook", "bundle install -j3 --quiet", "--", \
  "prehook", "bundle exec rails db:create db:migrate db:seed", "--" \
]
