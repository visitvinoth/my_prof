FROM ruby:2.5

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    && rm -rf /var/lib/apt/lists

## Install Node environment
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
COPY . .
RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD bundle exec puma -C config/puma.rb
