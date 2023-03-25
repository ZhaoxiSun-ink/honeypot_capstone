# Use the official Node.js LTS image
FROM node:16
COPY common/* /etc/
# Set the working directory
WORKDIR /usr/src/app

# Install the necessary libraries for Debian-based systems
RUN apt-get update && \
    apt-get install -y libkrb5-dev  python && \
    apt-get clean

# Copy package.json and package-lock.json to the working directory

# Install the dependencies
RUN ls
#COPY common/ /etc
COPY start_web.sh /
# Copy the application files
COPY src/ .
RUN npm install
RUN chmod +x /start_web.sh
# Expose the web server port
EXPOSE 3000

# Start the Node.js application
#CMD ["npm", "start"]
