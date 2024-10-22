FROM registry.docker.com/library/ruby:3.3.1-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    dos2unix \
    build-essential git \
    libvips \
    pkg-config \
    git \
    curl \
    libsqlite3-0 \
    libmariadb-dev-compat \
    libmariadb-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY Gemfile ./

RUN bundle install

COPY . .

RUN chmod +x ./bin/*

EXPOSE 3002

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
