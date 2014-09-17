FROM ruby:2.1

MAINTAINER Marcos Vanetta(marcosvanetta@gmail.com)

ENV HTTP_USERNAME username
ENV HTTP_PASSWORD password
ENV GMAIL_USERNAME test@gmail.com
ENV GMAIL_PASSWORD testpass

RUN apt-get update
RUN apt-get install -y nodejs npm git git-core

ADD . /app

WORKDIR /app

RUN bundle

RUN rake db:migrate

EXPOSE 3000

ENTRYPOINT rails s
