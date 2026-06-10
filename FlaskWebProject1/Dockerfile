# Use Python 3.9-slim as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire Flask application into the container
COPY . .

# Expose port 80
EXPOSE 80

# Command to run the Flask application
CMD ["python", "app.py"]
