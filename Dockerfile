FROM golang:1.23 AS build

WORKDIR /app

RUN go install github.com/dubyte/dir2opds@v1.3.0

# Final image
FROM debian:stable-slim
COPY --from=build /go/bin/dir2opds /usr/local/bin/dir2opds

RUN useradd -m dir2opds
USER dir2opds

EXPOSE 8080
CMD ["dir2opds", "-calibre", "-dir", "/books", "-port", "8080", "-hide-dot-files"]
