FROM ruby:2.1

ENV LAST_REFRESHED 01.24.2015

RUN apt-get update

RUN mkdir /home/app
WORKDIR /home/app

# add gemfiles to separate dependency changes from app changes
ADD Gemfile /home/app/
ADD Gemfile.lock /home/app/

RUN bundle
ADD . /home/app

ENTRYPOINT rackup
