FROM golang:1.11.2-alpine3.7 AS builder
WORKDIR /go/src/github.com/edgexfoundry/edgex-go

# The main mirrors are giving us timeout issues on builds periodically.
# So we can try these.
RUN echo http://nl.alpinelinux.org/alpine/v3.7/main > /etc/apk/repositories; \
    echo http://nl.alpinelinux.org/alpine/v3.7/community >> /etc/apk/repositories

RUN apk update && apk add make glide git
COPY . .

RUN go build hello.go

FROM docker:latest

COPY --from=builder /go/src/github.com/edgexfoundry/edgex-go/hello /

RUN apk add --no-cache py-pip
RUN pip install docker-compose --force --upgrade
RUN apk --no-cache add curl
RUN curl -o docker-compose.yml https://raw.githubusercontent.com/edgexfoundry/developer-scripts/master/compose-files/docker-compose-delhi-0.7.0.yml

#ENTRYPOINT tail -f /dev/nul
ENTRYPOINT ./hello
