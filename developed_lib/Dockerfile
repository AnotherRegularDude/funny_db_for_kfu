FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y build-essential

RUN mkdir /developed_lib
WORKDIR /developed_lib

COPY funny_db.gemspec /developed_lib/funny_db.gemspec
COPY Gemfile /developed_lib/Gemfile
COPY lib/funny_db/version.rb /developed_lib/lib/funny_db/version.rb

RUN bundle install

COPY . /developed_lib
