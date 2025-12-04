FROM python:3.12-slim

# Create base directory
WORKDIR /app

# System dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-libmysqlclient-dev \
        pkg-config \
        gcc && \
    rm -rf /var/lib/apt/lists/*

# Copy ONLY requirements first
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r 111/requirements.txt

# Copy everything INTO /app
COPY . /app/

# Set working directory to the Django project root
WORKDIR /app/111/school

# Start Gunicorn from inside this folder
CMD ["gunicorn", "school.wsgi:application", "--bind", "0.0.0.0:8080"]
