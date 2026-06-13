# 1. Using Node.js to build the code. 'alpine' is a tiny Linux version.
FROM node:20-alpine as build-stage

# 2. Setting the working directory inside the container
WORKDIR /app

# 3. Copying the 'package' files first.  
COPY package*.json ./

# 4. Installing the libraries needed to build your React app
RUN npm install

# 5. Copying the entire frontend source code into the container
COPY . .

# 6. Defining that we expect these variables during the build
ARG VITE_API_URL
ARG VITE_WS_URL

# Setting them as environment variables for the build process
ENV VITE_API_URL=$VITE_API_URL
ENV VITE_WS_URL=$VITE_WS_URL

# 7. This command turns the React/TS code into plain HTML/JS/CSS and puts it in a folder called 'dist'.
RUN npm run build

# 8. Switching to Nginx. We don't need Node.js anymore!
FROM nginx:stable-alpine as production-stage

# Trivy showed vulnerabitlity for some old version packages. So, This updates Alpine's package manager and upgrades all installed packages.
RUN apk update && apk upgrade --no-cache

# 9. Taking the 'dist' folder we just created in Stage 1 and  moving it to Nginx's folder where it serves public files.
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 10. Copying our custom configuration for Nginx to handle React Router properly.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 11. Opening Port 80 (Standard for web traffic)
EXPOSE 80

# 12. Starting Nginx and keeping it running in the foreground.
CMD ["nginx", "-g", "daemon off;"]