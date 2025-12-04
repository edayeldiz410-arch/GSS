# Base Python image
FROM python:3.12-slim

# Install system dependencies for mysqlclient and build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-libmysqlclient-dev \
        pkg-config \
        gcc && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Install Python dependencies
COPY 111/requirements.txt .
RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy project
COPY . .

# Expose port (Railway will set $PORT)
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Start command (adjust path if manage.py is under 111/)
CMD ["gunicorn", "school.wsgi", "--bind", "0.0.0.0:8080"]
