# Use a small, official nginx image
FROM nginx:alpine

# Copy your HTML (and any other static files) into nginx's default public folder
COPY . /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80


