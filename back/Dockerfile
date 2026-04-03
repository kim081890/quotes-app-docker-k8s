FROM python:3.6

# Expose the API port
EXPOSE 3000

# Set working directory
WORKDIR /app

# Install dependencies first (Docker layer caching optimization)
COPY requirements.txt /app
RUN pip install -r requirements.txt

# Copy application code
COPY back.py /app

# Start the API server
CMD python back.py