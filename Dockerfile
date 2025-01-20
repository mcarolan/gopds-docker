# Stage 1: Build the gopds binary from source
FROM golang:1.20 AS build

# Create and change to the build directory
WORKDIR /app

# Clone the latest source from GitHub
RUN git clone https://github.com/futuretap/gopds.git .

# Build the gopds binary
RUN go build -o /gopds

# Stage 2: Create a minimal runtime image
FROM debian:stable-slim

# Copy the compiled binary from the builder stage
COPY --from=build /gopds /usr/local/bin/gopds

# Create a non-root user (recommended for security)
RUN useradd -m gopdsuser
USER gopdsuser

# Expose port 8080 for gopds
EXPOSE 8080

# Default command: serve /books folder on port 8080
CMD ["gopds", "-library", "/books", "-port", "8080"]
