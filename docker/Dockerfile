# Stage 1: Build

# Full Bullseye image to build the app
FROM node:18-bullseye AS builder
# Database URL 
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
# Set destination for copy
WORKDIR /app
# Copy Node App dependencies 
COPY /app/package*.json /app/pnpm-lock.yaml ./
# Install dependencies / creates node modules
RUN npm install -g pnpm
RUN pnpm install 
# Copy source code
COPY /app ./
# Skip database check
ENV SKIP_DB_CHECK=1
# Build phase
RUN pnpm build


# Stage 2: Production 

# Lightweight image for production 
FROM node:18-alpine AS runner
# Set destination for copy
WORKDIR /app
# Copy all dependencies
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/generated ./generated
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./
# Copy Next.js standalone build (to run app)
COPY --from=builder /app/.next/standalone ./
# Copy app code
COPY --from=builder /app/src ./src
# Set permissions for node user
RUN chown -R node:node /app

USER node

EXPOSE 3000

ENV HOST=0.0.0.0
ENV PORT=3000

CMD ["node", "server.js"]