# Kamal v2 Configuration Summary

This document summarizes the Kamal v2 deployment configuration created for the Koal application.

## Key Changes from docker-compose

### 1. Proxy Configuration
- **Removed**: Traefik configuration
- **Added**: kamal-proxy with automatic SSL
- **Port**: App runs on port 3000 (specified via `proxy.app_port`)
- **SSL**: Automatic Let's Encrypt certificates via `proxy.ssl: true`

### 2. Database Migrations
- **Method**: Pre-connect hook (`.kamal/hooks/pre-connect`)
- **Command**: `bin/rails db:prepare`
- **Databases**: Automatically creates and migrates all SQLite databases:
  - primary (`storage/koal_production.sqlite3`)
  - cache (`storage/koal_production_cache.sqlite3`)
  - queue (`storage/koal_production_queue.sqlite3`)
  - cable (`storage/koal_production_cable.sqlite3`)
  - errors (`storage/koal_production_errors.sqlite3`)

### 3. Services
- **Web**: Rails app with Puma (port 3000)
- **Worker**: Solid Queue background jobs (`bin/jobs`)

### 4. Asset Compilation
- **Dockerfile**: Uncommented Vite build and Rails asset precompilation
- **Build process**:
  1. `bundle exec vite build` (compiles Vite assets)
  2. `bundle exec rails assets:precompile` (precompiles Rails assets)
- **Asset bridging**: Configured via `asset_path: /app/public/assets`

### 5. Healthchecks
- **Endpoint**: `/up`
- **Configuration**: Under `proxy.healthcheck`
- **Interval**: 10 seconds
- **Timeout**: 5 seconds
- **Max attempts**: 7

### 6. Volumes
- `koal_storage:/app/storage` - SQLite databases
- `koal_public:/app/public` - Public assets

### 7. Command Aliases
Added for convenience:
- `kamal console` - Rails console
- `kamal dbconsole` - Database console
- `kamal logs` - Follow logs
- `kamal migrate` - Run migrations

## Files Created/Modified

### Created:
1. `config/deploy.yml` - Main Kamal v2 configuration
2. `.kamal/secrets` - Environment variables template
3. `.kamal/hooks/pre-connect` - Database migration hook
4. `.kamal/README.md` - Deployment guide
5. `.kamal/KAMAL_V2_CHANGES.md` - This file

### Modified:
1. `Dockerfile` - Uncommented asset compilation steps
2. `.gitignore` - Added `.kamal/secrets`

## Environment Variables Required

Set these before deploying:

```bash
export SECRET_KEY_BASE="..."
export SMTP_SERVER="..."
export SMTP_PORT="587"
export SMTP_USERNAME="..."
export SMTP_PASSWORD="..."
export EMAIL_DEFAULT_FROM="noreply@example.com"
export EMAIL_REPORT_EXCEPTION_TO="admin@example.com"
```

## Deployment Workflow

1. **Build**: Docker image built with Vite and Rails assets
2. **Push**: Image pushed to registry
3. **Pre-connect hook**: Runs `db:prepare` on existing container
4. **Deploy**: New containers started
5. **Health check**: kamal-proxy monitors `/up` endpoint
6. **Switch traffic**: Once healthy, traffic switches to new containers
7. **Cleanup**: Old containers removed (keeps last 5 by default)

## Next Steps

1. Update placeholders in `config/deploy.yml`:
   - `YOUR_SERVER_IP`
   - `YOUR_DOMAIN`
   - `YOUR_REGISTRY_USERNAME`

2. Set environment variables in `.kamal/secrets`

3. Run initial setup:
   ```bash
   kamal setup
   ```

4. Deploy:
   ```bash
   kamal deploy
   ```
