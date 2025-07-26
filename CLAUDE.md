# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Papermark is an open-source document-sharing platform (DocSend alternative) built with:
- Repository: git@github.com:grait-io/papermark.git
- Next.js 14 (App Router) with TypeScript
- Prisma ORM with PostgreSQL
- Tailwind CSS + shadcn/ui components
- NextAuth.js for authentication
- Trigger.dev v3 for background jobs

## Essential Commands

```bash
# Development
npm run dev              # Start development server (http://localhost:3000)
npm run dev:prisma       # Generate Prisma client + run migrations + start dev server

# Database
npx prisma generate      # Regenerate Prisma client after schema changes
npx prisma migrate dev   # Apply database migrations in development
npx prisma studio        # Open Prisma Studio to view/edit database

# Code Quality
npm run lint            # Run ESLint
npm run format          # Format code with Prettier (includes import sorting)

# Background Jobs
npm run trigger:v3:dev  # Start Trigger.dev development environment

# Email Development
npm run email           # Start email template development server
```

## Architecture Overview

### Directory Structure
- `/app` - Next.js App Router pages and API routes
  - `/(auth)` - Authentication pages
  - `/api` - API endpoints following RESTful patterns
- `/components` - React components organized by feature
- `/lib` - Core business logic
  - `/swr` - Custom hooks for data fetching (use these for client-side data)
  - `/emails` - Email templates using React Email
  - `/trigger` - Background job definitions
- `/ee` - Enterprise Edition features (conversations, permissions)
- `/prisma` - Database schema and migrations

### Key Patterns

**API Routes**: Located in `/app/api/`, follow pattern:
```typescript
// GET requests
export async function GET(request: Request) { }
// POST requests  
export async function POST(request: Request) { }
```

**Data Fetching**: Use SWR hooks from `/lib/swr/`:
```typescript
import { useDocuments } from "@/lib/swr/use-documents";
const { documents, loading, error } = useDocuments();
```

**Authentication**: Check auth status using:
```typescript
import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth/options";
const session = await getServerSession(authOptions);
```

**Background Jobs**: Define in `/lib/trigger/` using Trigger.dev v3:
```typescript
import { task } from "@trigger.dev/sdk/v3";
export const myTask = task({
  id: "my-task",
  run: async (payload) => { }
});
```

### Database Schema

Key models in Prisma schema:
- `User` - User accounts with authentication
- `Team` - Teams for collaboration
- `Document` - Uploaded documents
- `DataRoom` - Secure document collections
- `Link` - Shareable links with extensive options
- `View` - Analytics tracking

Always use Prisma for database operations:
```typescript
import { prisma } from "@/lib/server/prisma";
const documents = await prisma.document.findMany();
```

### UI Components

- Use `/components/ui/` for base components (shadcn/ui)
- Follow existing component patterns for consistency
- Tailwind classes with cn() utility for conditional styling
- Icons from lucide-react

### Environment Variables

Critical variables that must be set:
- `POSTGRES_PRISMA_URL` - Database connection
- `NEXTAUTH_SECRET` - Authentication secret  
- `STORAGE_PROVIDER` - Either "vercel-blob" or "s3"
- `TINYBIRD_TOKEN` - Analytics (optional but recommended)

## Development Workflow

1. **Feature Development**:
   - Create feature branch from main
   - Add new API routes in `/app/api/`
   - Add React components in `/components/`
   - Update Prisma schema if needed, then run migrations

2. **Database Changes**:
   - Modify `/prisma/schema.prisma`
   - Run `npx prisma migrate dev --name describe_change`
   - Update related TypeScript types will auto-generate

3. **Adding Background Jobs**:
   - Create task in `/lib/trigger/`
   - Use `task.run()` or `task.batchRun()` to execute
   - Monitor in Trigger.dev dashboard

4. **Styling**:
   - Use Tailwind classes
   - Follow existing color scheme with CSS variables
   - Responsive design with Tailwind breakpoints

## Important Notes

- The project uses Next.js App Router - avoid pages directory
- Authentication is required for most features - always check session
- File uploads configured for Vercel Blob or S3 based on env
- Analytics events sent to Tinybird - use existing patterns
- Rate limiting implemented with Upstash Redis
- Enterprise features in `/ee` directory require special handling