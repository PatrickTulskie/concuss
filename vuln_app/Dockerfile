from ruby:3.2
COPY Gemfile Gemfile.lock /app/
WORKDIR /app
RUN bundle install
COPY . /app/

EXPOSE 4567

CMD ["ruby", "vuln_app.rb", "-o", "0.0.0.0"]
