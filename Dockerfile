FROM node:latest
WORKDIR /app
COPY package.json package-lock.json ./
 
RUN npm ci --prod
 
FROM node:slim
 
WORKDIR /app
COPY --from=0 /app .
COPY . .
CMD ["node", "server.js"]