# Stage 1: Build the React application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy all source code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve the application using a lightweight static server
FROM node:20-alpine AS runner

WORKDIR /app

# Install 'serve' globally to host static files
RUN npm install -g serve

# Copy build artifacts (yeh builder stage se public build folder ko copy karega)
# Agar aapka build folder 'build' hai toh niche wala chalega, agar 'dist' hai toh 'dist' likhein. 
# Create React App ke liye default 'build' hota hai.
COPY --from=builder /app/build ./build

# Expose port 3000 for Kubernetes
EXPOSE 3000

# Run the app using serve on port 3000
CMD ["serve", "-s", "build", "-l", "3000"]