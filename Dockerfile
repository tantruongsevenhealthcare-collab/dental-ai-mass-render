FROM node:22-bookworm-slim

WORKDIR /app
COPY dental-ai-mass-render-source.tar.gz /tmp/dental-ai-mass-render-source.tar.gz

RUN tar -xzf /tmp/dental-ai-mass-render-source.tar.gz -C /app \
  && rm /tmp/dental-ai-mass-render-source.tar.gz \
  && npm install -g corepack@latest \
  && corepack pnpm install --frozen-lockfile \
  && corepack pnpm run build

ENV NODE_ENV=production
CMD ["sh", "-c", "for f in /etc/secrets/DATABASE_URL /etc/secrets/DATABASE_URL.secret /etc/secrets/database_url; do if [ -s \"$f\" ]; then export DATABASE_URL=\"$(cat \"$f\")\"; break; fi; done; exec node dist/index.js"]
