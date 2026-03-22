# Stage 1: Build

# Full Bullseye image to build the app
FROM node:18-bullseye AS builder
# Set destination for copy
WORKDIR /app
# Copy Node App dependencies 
COPY /app/package*.json /app/pnpm-lock.yaml ./
# Install dependencies / creates node_modules
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
FROM node:18-alpine 
# Set destination for copy
WORKDIR /app
# Install pnpm
RUN npm install -g pnpm
# Copy all dependencies
COPY --from=builder /app/package.json ./
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/generated ./generated
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
# Copy source code
COPY --from=builder /app/src ./src

# Set permissions for node user
RUN chown -R node:node /app

USER node

EXPOSE 3000

CMD ["pnpm", "start-docker"]