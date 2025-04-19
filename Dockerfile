FROM debian:bullseye-slim

# Install basic tools
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils python3 python3-pip && \
    apt-get clean

# Download and extract Flutter
RUN curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz && \
    tar xf flutter_linux_3.19.6-stable.tar.xz && \
    mv flutter /opt/flutter

# Set PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Accept Flutter licenses
RUN flutter doctor -v

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Get dependencies & build web
RUN flutter pub get
RUN flutter build web

# Expose port for serving
EXPOSE 8080

# Serve via Python HTTP server
CMD ["sh", "-c", "cd build/web && python3 -m http.server 8080"]
