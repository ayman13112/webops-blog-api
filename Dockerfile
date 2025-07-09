FROM ruby:3.2

WORKDIR /app

# Install node and PostgreSQL client (for Rails & JS dependencies)
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Install bundler and dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the app source code
COPY . .

# (Remove bootsnap precompile to prevent build crash)
