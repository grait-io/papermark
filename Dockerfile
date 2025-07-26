# Build stage
FROM node:20-alpine AS builder

# Install dependencies for native modules
RUN apk add --no-cache libc6-compat netcat-openbsd python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
# Copy entire prisma directory including schema folder
COPY prisma ./prisma/

# Install dependencies
RUN npm ci

# Copy application code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Set build-time environment variables
ENV NEXT_PUBLIC_WEBHOOK_BASE_HOST=localhost
ENV NEXT_PUBLIC_APP_BASE_HOST=localhost
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV HANKO_API_KEY=placeholder-for-build
ENV NEXT_PUBLIC_HANKO_TENANT_ID=placeholder-for-build

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS runner

# Install dependencies for native modules
RUN apk add --no-cache libc6-compat netcat-openbsd

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy necessary files from builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
# Copy entire prisma directory with all subdirectories
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma
COPY --from=builder /app/package*.json ./

# Copy entrypoint script
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

# Install production dependencies for Prisma
RUN npm install prisma @prisma/client

# Set environment to production
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Change ownership
RUN chown -R nextjs:nodejs /app

USER nextjs

# Expose port (will be mapped to the port defined in docker-compose)
EXPOSE 3000

# Start the application
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["node", "server.js"]