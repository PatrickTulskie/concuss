from ruby:4.0
COPY . /app/
WORKDIR /app
RUN bundle install
