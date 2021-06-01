FROM ruby:slim-buster as builder

# Install dependencies for gems
RUN apt-get update -y && apt-get -y --no-install-recommends install \
    libpq-dev \
    ruby-dev \
    build-essential      

# Add and install gem dependencies
COPY Gemfile Gemfile.lock /app/
RUN bash -l -c "cd /app && bundle install -j4"

FROM ruby:slim-buster as app

# Install dependencies for gems and remove vuln : [liblz4-1] current vulnerability in Debian 10.9
RUN apt-get update -y && apt-get -y --no-install-recommends install \
    libpq-dev \
    liblz4-1 \                      
    && rm -rf /var/lib/apt/lists/*   

LABEL maintainer="James Rudd"

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app
COPY . /app

RUN chown 1000:1000 /app
WORKDIR /app
USER 1000

EXPOSE 8080
ENV RAILS_LOG_TO_STDOUT=false

CMD bundle exec puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-1} -p 8080 -e ${RACK_ENV:-production} --preload
