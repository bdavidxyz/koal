# Dockerfile - Production
# Build: docker build -t koal .
# Run: docker run -p 3000:3000 koal

# ============================================
# Stage 1: Base - Ruby environment
# ============================================
FROM ruby:4.0.2-bookworm AS base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libvips \
    libpq-dev \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# ============================================
# Stage 2: Dependencies - Gems and npm packages
# ============================================
FROM base AS deps

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 1 --retry 3

# Copy package.json and install npm packages
COPY package.json package-lock.json ./
RUN npm ci --legacy-peer-deps

# ============================================
# Stage 3: Build - Compile assets
# ============================================
FROM deps AS build

# Copy the rest of the application
COPY . .

# # Set environment for production build
# ENV RAILS_ENV=production

# # Build Vite assets for production FIRST
# RUN bundle exec vite build

# # Then precompile Rails assets (includes manifest)
# RUN bundle exec rails assets:precompile

# ============================================
# Stage 4: Production - Final image
# ============================================
FROM base

# Copy Gemfile (for runtime bundle check)
COPY --from=deps /usr/local/bundle /usr/local/bundle

# Copy built application
COPY --from=build /app .

# Create storage directory for SQLite databases
RUN mkdir -p storage log tmp

# Expose port
EXPOSE 3000

# Environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Start command (can be overridden by docker-compose)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]