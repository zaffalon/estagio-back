# Use the barebones version of Ruby 2.3.1.
FROM ruby:2.3.1-slim
ENV LANG C.UTF-8

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Phillipe Gustavo <phillipe@zagu.com.br>

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update -qq && \
    apt-get install -y mysql-client \
                       libmysqlclient-dev \
                       build-essential \
                       --fix-missing \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

#RUN apt-get update -qq && \
#    apt-get install -y mysql-client \
#                       vim \
#                       build-essential \
#                       --fix-missing \
#                       --no-install-recommends && \
#    rm -rf /var/lib/apt/lists/*

#Cache bundle install
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN gem install bundler && bundle install --jobs 20 --retry 5

ENV APP_ROOT /zagu-estagio-back
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
COPY . $APP_ROOT
#
## Set an environment variable to store where the app is installed to inside
## of the Docker image.
#ENV INSTALL_PATH /zagu-estagio-back
#RUN mkdir -p $INSTALL_PATH
#
## This sets the context of where commands will be ran in and is documented
## on Docker's website extensively.
#WORKDIR $INSTALL_PATH
#
## Ensure gems are cached and only get updated when they change. This will
## drastically increase build times when your gems do not change.
#COPY Gemfile Gemfile.lock ./
#RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test
#
## Set Rails to run in production
#ENV RAILS_ENV production
#ENV RACK_ENV production

# Copy in the application code from your work station at the current directory
# over to the working directory.
#COPY . .

# Provide dummy data to Rails so it can pre-compile assets.
#RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
#VOLUME ["$INSTALL_PATH/public"]

EXPOSE 3000

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec unicorn -c config/unicorn.rb