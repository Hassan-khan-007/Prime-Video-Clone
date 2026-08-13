# Stage 1: Build the application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files to leverage Docker layer caching
COPY package*.json ./

# Install all dependencies
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Stage 2: Run the application in production
FROM node:20-alpine AS runner

WORKDIR /app

# Copy package files and install ONLY production dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy application files from the builder stage
COPY --from=builder /app ./

# Create a non-root user for security best practices
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

USER nodejs

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]