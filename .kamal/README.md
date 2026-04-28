# Kamal Deployment Guide

This directory contains Kamal deployment configuration for the Koal application.

## Prerequisites

1. Install Kamal:
   ```bash
   gem install kamal
   ```

2. Set up your server with Docker installed

3. Configure SSH access to your server

## Configuration

### 1. Update `config/deploy.yml`

Replace the following placeholders:
- `YOUR_SERVER_IP` - Your production server IP address
- `YOUR_DOMAIN` - Your application domain (e.g., koal.example.com)
- `YOUR_REGISTRY_USERNAME` - Docker registry username (if using private registry)
- `YOUR_EMAIL` - Email for Let's Encrypt SSL certificates

### 2. Set Environment Variables

Before deploying, set the required environment variables in your shell or CI/CD:

```bash
export SECRET_KEY_BASE="your_secret_key_base"
export SMTP_SERVER="smtp.example.com"
export SMTP_PORT="587"
export SMTP_USERNAME="your_smtp_username"
export SMTP_PASSWORD="your_smtp_password"
export EMAIL_DEFAULT_FROM="noreply@example.com"
export EMAIL_REPORT_EXCEPTION_TO="admin@example.com"
```

Or create a local `.kamal/secrets` file (already templated, just fill in values).

## Deployment Commands

### Initial Setup

```bash
# Set up the server (install Docker, create directories, etc.)
kamal setup
```

### Deploy

```bash
# Deploy the application
kamal deploy
```

### Other Useful Commands

```bash
# Check application status
kamal app details

# View logs
kamal app logs

# Restart the application
kamal app restart

# Run Rails console
kamal app exec -i --reuse "bin/rails console"

# Run database migrations
kamal app exec "bin/rails db:migrate"

# Rollback to previous version
kamal rollback

# Remove the application
kamal remove
```

## Architecture

The deployment includes:

- **Web service**: Rails application with Puma server (port 3000)
- **Worker service**: Solid Queue background job processor
- **Traefik**: Reverse proxy with automatic SSL via Let's Encrypt
- **Volumes**: Persistent storage for SQLite databases and public assets

## Differences from docker-compose

Kamal provides:
- Zero-downtime deployments
- Automatic SSL certificate management
- Built-in health checks
- Easy rollback capabilities
- Multi-server support
- Integrated secrets management

## Troubleshooting

### Check container status
```bash
kamal app details
```

### View application logs
```bash
kamal app logs --tail 100
```

### SSH into the server
```bash
ssh root@YOUR_SERVER_IP
```

### Check Docker containers on server
```bash
docker ps
```
