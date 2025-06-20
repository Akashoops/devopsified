# Stage 1: Build the Go application
FROM golang:1.22 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum for dependency resolution
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go app
RUN go build -o go-web-app

# Stage 2: Create a minimal runtime image
FROM gcr.io/distroless/base-debian12

# Set the working directory
WORKDIR /

# Copy the compiled binary from builder stage
COPY --from=builder /app/go-web-app .

COPY --from=builder /app/static ./static

# Expose port 8080 (the app listens on this)
EXPOSE 8080

# Run the app
CMD ["./go-web-app"]
