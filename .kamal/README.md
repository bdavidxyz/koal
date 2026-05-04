# Kamal v2 Deployment Guide

This directory contains Kamal v2 deployment configuration for the Koal application.

## Prerequisites

1. Install Kamal v2:

   ```bash
   gem install kamal
   ```

2. Set up your server with Docker installed (Kamal can do this for you)

3. Configure SSH access to your server (passwordless SSH key recommended)

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

# View logs (using alias)
kamal logs

# Restart the application
kamal app restart

# Run Rails console (using alias)
kamal console

# Run database console (using alias)
kamal dbconsole

# Run database migrations (using alias)
kamal migrate

# Or manually:
kamal app exec "bin/rails db:migrate"

# Rollback to previous version
kamal rollback [VERSION]

# Remove the application
kamal remove
```

## Architecture

The deployment includes:

- **Web service**: Rails application with Puma server (port 3000)
- **Worker service**: Solid Queue background job processor (`bin/jobs`)
- **kamal-proxy**: Built-in reverse proxy with automatic SSL via Let's Encrypt
- **Volumes**: Persistent storage for SQLite databases and public assets
- **Pre-connect hook**: Automatically runs `db:prepare` to create databases and run migrations

## Differences from docker-compose

Kamal v2 provides:

- Zero-downtime deployments with health checks
- Automatic SSL certificate management via kamal-proxy
- Built-in health checks (monitors `/up` endpoint)
- Easy rollback capabilities
- Multi-server support
- Integrated secrets management
- Deployment hooks for custom scripts
- Asset bridging to prevent 404s during deployments

## Database Migrations

Database migrations are handled automatically via the `.kamal/hooks/pre-connect` hook.

Before each deployment, the hook runs:

```bash
kamal app exec --roles web --reuse "bin/rails db:prepare"
```

This ensures:

- All SQLite databases are created (primary, cache, queue, cable, errors)
- All pending migrations are run
- The schema is loaded for new databases

The hook runs **before** traffic is switched to the new containers, ensuring zero-downtime deployments.

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
