FROM node:latest as tools
WORKDIR /app
COPY package.json package-lock.json ./

RUN npm ci --omit=dev

FROM node:18.2.0-alpine3.15

WORKDIR /app
COPY --from=tools /app .
COPY . .
CMD ["node", "server.js"]
