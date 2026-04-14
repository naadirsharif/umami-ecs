# Stage 1: Build

# Full Bullseye image to build the app
FROM node:20-bullseye AS builder
# Build-time database connection string required for Prisma 
ARG DATABASE_URL
# Set destination for copy
WORKDIR /app
# Copy Node App dependencies 
COPY /app/package*.json /app/pnpm-lock.yaml ./
# Install dependencies / creates node modules
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile
# Copy source code
COPY /app ./
# Skip database check
ENV SKIP_DB_CHECK=1
# Build phase
RUN pnpm build


# Stage 2: Runtime

# Lightweight image for runtime 
FROM node:20-alpine AS runner
# Set destination for copy
WORKDIR /app
# Copy all dependencies
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/generated ./generated
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next/static ./.next/static
# Copy Next.js standalone build (to run app)
COPY --from=builder /app/.next/standalone ./

# Run container as non-root user
USER node

EXPOSE 3000

ENV HOSTNAME=0.0.0.0
ENV PORT=3000

CMD ["node", "server.js"]