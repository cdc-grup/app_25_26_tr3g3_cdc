# --- Base Stage ---
FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
COPY packages/shared ./packages/shared
COPY apps/api/package.json ./apps/api/

# --- Builder Stage ---
FROM base AS builder
COPY . .
RUN pnpm install
RUN pnpm --filter @app/shared build || true
# Note: Building @app/api if needed, but for now we follow Sprint 0 basics.

# --- Development Stage ---
FROM builder AS development
ENV NODE_ENV=development
CMD ["pnpm", "--filter", "@app/api", "dev"]

# --- Production Builder Stage ---
FROM builder AS prod-builder
RUN pnpm --filter @app/api build

# --- Production Stage ---
FROM node:20-slim AS production
WORKDIR /app
ENV NODE_ENV=production
COPY --from=prod-builder /app/apps/api/dist ./dist
COPY --from=prod-builder /app/apps/api/package.json ./package.json
RUN npm install --omit=dev
CMD ["node", "dist/index.js"]
