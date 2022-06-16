FROM golang:1.18 AS build
WORKDIR /src

COPY go.mod ./
RUN go mod download

COPY cmd/ ./cmd/
RUN go build -o /usr/local/bin/riju-publicapi ./cmd/riju-publicapi

FROM ubuntu:22.04

COPY --from=build /usr/local/bin/riju-publicapi /usr/local/bin/
CMD ["/usr/local/bin/riju-publicapi"]
EXPOSE 80
