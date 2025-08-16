# Production image for Medusa app
FROM node:20-alpine

WORKDIR /app

# Enable yarn via corepack and install dependencies first for better caching
COPY package.json yarn.lock .yarnrc.yml ./
RUN corepack enable \
  && corepack prepare yarn@1.22.22 --activate \
  && yarn --version \
  && yarn install --frozen-lockfile

# Copy source and build
COPY . .
RUN yarn build

# Ensure start script is executable
RUN chmod +x ./src/scripts/start.sh

ENV NODE_ENV=development

EXPOSE 9000
CMD ["./src/scripts/start.sh"]
