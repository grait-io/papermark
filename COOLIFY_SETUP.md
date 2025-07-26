# Coolify Setup for Papermark

This guide explains how to deploy Papermark on Coolify.

## Prerequisites

1. A Coolify instance
2. PostgreSQL database (can be provisioned through Coolify)
3. Required API keys for external services

## Deployment Steps

### 1. Create a New Service

1. In Coolify, click "New Service"
2. Select "Docker Compose" as the deployment method
3. Connect your Git repository: `git@github.com:grait-io/papermark.git`

### 2. Configure Build

Set the following in your service configuration:

- **Docker Compose File**: `docker-compose.coolify.yml`
- **Port**: `25256` (or your preferred port)

### 3. Environment Variables

Configure these **required** environment variables in Coolify:

```env
# Application Port
APP_PORT=25256

# Database (use Coolify's PostgreSQL service)
DATABASE_URL=postgresql://user:password@postgres:5432/papermark

# Authentication
NEXTAUTH_SECRET=generate-a-32-character-secret-here
NEXTAUTH_URL=https://your-domain.com

# Public URLs
NEXT_PUBLIC_URL=https://your-domain.com
NEXT_PUBLIC_BASE_URL=https://your-domain.com
NEXT_PUBLIC_MARKETING_URL=https://your-domain.com

# Email (Required for notifications)
EMAIL_FROM=noreply@your-domain.com
RESEND_API_KEY=your-resend-api-key

# Document Encryption
DOCUMENT_ENCRYPTION_KEY=generate-another-32-character-secret

# Storage Provider
STORAGE_PROVIDER=vercel-blob
BLOB_READ_WRITE_TOKEN=your-vercel-blob-token
```

### 4. Optional Environment Variables

```env
# Google OAuth (for Google login)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret

# Analytics
TINYBIRD_TOKEN=your-tinybird-token

# Payments
STRIPE_SECRET_KEY=your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=your-stripe-webhook-secret
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key

# Background Jobs
TRIGGER_SECRET_KEY=your-trigger-secret-key
TRIGGER_API_URL=https://api.trigger.dev

# Redis (for rate limiting)
UPSTASH_REDIS_REST_URL=your-redis-url
UPSTASH_REDIS_REST_TOKEN=your-redis-token

# Queue Management
UPSTASH_QSTASH_URL=your-qstash-url
UPSTASH_QSTASH_TOKEN=your-qstash-token
```

### 5. Storage Configuration

#### Option A: Vercel Blob Storage (Recommended)
```env
STORAGE_PROVIDER=vercel-blob
BLOB_READ_WRITE_TOKEN=your-vercel-blob-token
NEXT_PUBLIC_VERCEL_BLOB_BASE_URL=https://your-blob-store.public.blob.vercel-storage.com
```

#### Option B: AWS S3
```env
STORAGE_PROVIDER=s3
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_S3_BUCKET_NAME=your-bucket-name
AWS_S3_REGION=us-east-1
```

### 6. Database Setup

1. **Using Coolify PostgreSQL**:
   - Create a PostgreSQL service in Coolify
   - Use the internal connection string in `DATABASE_URL`
   - Migrations run automatically on deployment

2. **External PostgreSQL**:
   - Ensure your database is accessible
   - Set the full connection string in `DATABASE_URL`

### 7. Deploy

1. Save your environment variables
2. Click "Deploy"
3. Monitor the deployment logs
4. Once deployed, visit your domain

## Post-Deployment

1. **First User**: Register the first user account - it will automatically have admin privileges
2. **Custom Domain**: Configure your domain in Coolify's service settings
3. **SSL**: Coolify handles SSL certificates automatically with Let's Encrypt

## Health Check

The application includes a health check endpoint at `/api/health` that Coolify uses to monitor the service status.

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Verify `DATABASE_URL` is correct
   - Check if PostgreSQL service is running
   - Ensure network connectivity between services

2. **Authentication Issues**
   - Verify `NEXTAUTH_URL` matches your domain
   - Ensure `NEXTAUTH_SECRET` is set and secure

3. **File Upload Issues**
   - Check storage provider configuration
   - Verify API tokens are valid
   - Ensure bucket/blob storage exists

### Logs

View logs in Coolify:
- Application logs: Service → Logs
- Build logs: Service → Deployments → View logs

### Environment Variables

Missing required variables will cause the application to fail. Check logs for specific error messages about missing configuration.

## Security Recommendations

1. Generate strong secrets for:
   - `NEXTAUTH_SECRET` (32+ characters)
   - `DOCUMENT_ENCRYPTION_KEY` (32+ characters)

2. Use Coolify's secret management for sensitive values

3. Restrict database access to internal network only

4. Enable rate limiting with Redis configuration

## Minimum Required Configuration

For a basic deployment, you need at least:

```env
APP_PORT=25256
DATABASE_URL=postgresql://...
NEXTAUTH_SECRET=...
NEXTAUTH_URL=https://your-domain.com
NEXT_PUBLIC_URL=https://your-domain.com
EMAIL_FROM=noreply@your-domain.com
RESEND_API_KEY=...
DOCUMENT_ENCRYPTION_KEY=...
STORAGE_PROVIDER=vercel-blob
BLOB_READ_WRITE_TOKEN=...
```

All other features are optional and can be added as needed.