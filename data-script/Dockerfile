FROM alpine

# Update packages and install mysql-client
RUN apk update && apk add mysql-client

# Copy scripts to /opt
COPY import.sh /opt
COPY mydatabase.sql /opt

# Set working directory
WORKDIR /opt

# Run the import script when container starts
CMD ["sh", "/opt/import.sh"]