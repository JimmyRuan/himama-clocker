FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp

COPY . /myapp

RUN gem install bundler && bundler update --bundler

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn \
libpq-dev && curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

#RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
#    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#    apt-get update && \
#    apt-get install -qq -y build-essential nodejs yarn \
#    libpq-dev \
#    mysql-client

#Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]