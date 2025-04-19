FROM debian:bullseye-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils python3 python3-pip && \
    apt-get clean

# Download and extract Flutter SDK
RUN curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz && \
    tar xf flutter_linux_3.19.6-stable.tar.xz && \
    rm flutter_linux_3.19.6-stable.tar.xz

# Add flutter to PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Accept Flutter licenses
RUN flutter doctor && flutter upgrade

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Build web
RUN flutter build web

# Expose the port
EXPOSE 10000

# Serve using Python HTTP server
CMD ["sh", "-c", "cd build/web && python3 -m http.server 10000"]
