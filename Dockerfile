FROM ruby:2.1

ENV LAST_REFRESHED 01.24.2015

RUN apt-get update

ADD . /home/app

WORKDIR /home/app
RUN bundle

ENTRYPOINT rackup
