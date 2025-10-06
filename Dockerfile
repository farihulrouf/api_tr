# Gunakan base image Ruby
FROM ruby:3.1.2

# Install dependencies yang dibutuhkan Rails + SQLite
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs

# Set working directory
WORKDIR /app

# Copy Gemfile dan Gemfile.lock dulu (untuk caching)
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy seluruh project
COPY . .

# Expose port Rails
EXPOSE 3000

# Jalankan server
CMD ["rails", "server", "-b", "0.0.0.0"]
