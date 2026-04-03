FROM python:3.6

# Expose the web UI port
EXPOSE 3001

# Copy ALL files (front.py, requirements.txt, templates/) into /app
COPY . /app

# Set working directory
WORKDIR /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Start the frontend web server
CMD python front.py