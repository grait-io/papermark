# Docker Setup for Papermark

This guide explains how to run Papermark using Docker Compose.

## Quick Start

1. **Copy environment variables**
   ```bash
   cp .env.example .env
   ```

2. **Configure environment variables**
   Edit `.env` and set the required variables. The most important ones for Docker:
   - `APP_PORT` - Application port (default: 25256)
   - `POSTGRES_USER` - PostgreSQL username (default: papermark)
   - `POSTGRES_PASSWORD` - PostgreSQL password (default: papermark)
   - `NEXTAUTH_SECRET` - Generate a secure secret for authentication
   - `STORAGE_PROVIDER` - Set to "vercel-blob" or "s3"

3. **Start the application**
   ```bash
   docker compose up -d
   ```

   This will:
   - Build the Papermark application image
   - Start PostgreSQL database
   - Run database migrations automatically
   - Start the application on port 25256 (or your configured port)

4. **Access the application**
   Open http://localhost:25256 in your browser

## Configuration

### Port Configuration

The application port can be configured in multiple ways:

1. **Via .env file** (recommended)
   ```env
   APP_PORT=25256
   ```

2. **Via environment variable**
   ```bash
   APP_PORT=8080 docker compose up
   ```

3. **For Coolify**
   Set the `APP_PORT` environment variable in your Coolify service configuration

### Database Configuration

PostgreSQL settings can be customized:
```env
POSTGRES_USER=papermark
POSTGRES_PASSWORD=your-secure-password
POSTGRES_DB=papermark
POSTGRES_PORT=5432
```

### Storage Configuration

For file uploads, configure either Vercel Blob or S3:

**Vercel Blob:**
```env
STORAGE_PROVIDER=vercel-blob
BLOB_READ_WRITE_TOKEN=your-token
```

**AWS S3:**
```env
STORAGE_PROVIDER=s3
AWS_ACCESS_KEY_ID=your-key-id
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_S3_BUCKET_NAME=your-bucket
AWS_S3_REGION=us-east-1
```

## Management Commands

### View logs
```bash
docker compose logs -f app
```

### Stop services
```bash
docker compose down
```

### Stop and remove volumes (caution: deletes data)
```bash
docker compose down -v
```

### Run database migrations manually
```bash
docker compose exec app npx prisma migrate deploy
```

### Access database
```bash
docker compose exec postgres psql -U papermark
```

### Rebuild after code changes
```bash
docker compose build app
docker compose up -d app
```

## Troubleshooting

### Port already in use
Change the `APP_PORT` in your `.env` file to a different port

### Database connection issues
Ensure PostgreSQL is healthy:
```bash
docker compose ps
docker compose logs postgres
```

### Migration failures
Check migration logs:
```bash
docker compose logs app | grep -i migration
```

## Production Considerations

1. **Use strong passwords** for PostgreSQL and NextAuth secret
2. **Configure SSL** with a reverse proxy (nginx, Caddy, Traefik)
3. **Set up backups** for the PostgreSQL volume
4. **Monitor resources** and adjust Docker resource limits as needed
5. **Use external PostgreSQL** for better performance and management

## Volumes

The setup creates two named volumes:
- `postgres_data` - PostgreSQL database files
- `app_uploads` - Application uploaded files (if not using external storage)

Back these up regularly in production environments.