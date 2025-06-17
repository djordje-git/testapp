# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
# Install NestJS CLI globally
RUN npm install -g @nestjs/cli
COPY . .
RUN npm run build

# Stage 2: Run
FROM node:18-slim
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist

# Add a non-root user and switch to it
RUN useradd -m appuser
USER appuser

EXPOSE 11000
CMD ["node", "dist/main"]

## Build the Docker Image:
# Open your terminal, navigate to the root directory of your project, and run the following command:
# docker build -t hello-goldbach-app .

## you can run the Docker container using the following command:
# docker run -d -p 11000:11000 hello-goldbach-app