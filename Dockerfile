from ruby:3.2
COPY . /app/
WORKDIR /app
RUN bundle install
