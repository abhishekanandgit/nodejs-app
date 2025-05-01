# Use Node.js official image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Expose the app port
EXPOSE 3000

# Run the app
CMD ["npm", "start"]
