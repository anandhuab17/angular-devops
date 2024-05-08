# Use node image as base image for building Angular application
FROM node:16 AS builder

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the Angular app with production configuration
RUN npm run build --prod

# Use nginx image to serve the built Angular application
FROM nginx:alpine

# Copy the built app from the previous stage into the nginx public directory
COPY --from=builder /app/dist/angular-devops /usr/share/nginx/html

# Expose port 80
EXPOSE 5002

# Start nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]
