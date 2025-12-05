FROM python:3.12-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-libmysqlclient-dev \
        pkg-config \
        gcc && \
    rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy requirements
COPY 111/requirements.txt /app/requirements.txt

# Install Python dependencies
RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

# Copy all project files
COPY . .

# Environment
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH="/app/111/school:$PYTHONPATH"

# Collect static files and start Django with gunicorn binding to the PORT env var
RUN . /opt/venv/bin/activate && python /app/111/school/manage.py collectstatic --noinput || true

# Use shell form so $PORT expands at runtime (Railway provides PORT)
CMD gunicorn school.wsgi:application --chdir 111/school --bind 0.0.0.0:$PORT --workers 2
