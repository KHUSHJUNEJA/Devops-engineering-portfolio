# Use a lightweight Python base image
FROM python:3.12-slim

# Prevent Python from creating .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Send Python output directly to the container logs
ENV PYTHONUNBUFFERED=1

# Set the application working directory
WORKDIR /app

# Install Python dependencies first
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django application
COPY . .

# Django application port
EXPOSE 8000

# Run the application using Gunicorn
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "1"]
