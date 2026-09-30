# Stage 1: Build the React application
FROM node:20-alpine AS builder

WORKDIR /app

# Install Python, build tools, Avahi, and ZeroMQ development headers required for native modules
RUN apk add --no-cache python3 make g++ avahi-dev avahi-compat-libdns_sd zeromq zeromq-dev

# Copy package files and install dependencies
COPY package*.json ./

# Increase npm network timeout and retry limits to prevent ETIMEDOUT errors
RUN npm config set fetch-retries 10 \
    && npm config set fetch-retry-maxtimeout 300000 \
    && npm install --network-concurrency 1

# Copy all source code
COPY . .

# Build the React app (react-scripts build outputs to 'build')
RUN npm run build

# Stage 2: Serve the application using a lightweight static server
FROM node:20-alpine AS runner

WORKDIR /app

# Install 'serve' globally to host static files
RUN npm install -g serve

# Copy the built files from builder stage (Create React App uses 'build')
COPY --from=builder /app/build ./build

# Expose port 3000 for Kubernetes
EXPOSE 3000

# Run the app using serve on port 3000
CMD ["serve", "-s", "build", "-l", "3000"]
