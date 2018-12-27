# Build step
FROM golang AS build
RUN mkdir -p $GOPATH/src/xz
ADD . $GOPATH/src/xz
WORKDIR $GOPATH/src/xz
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -vendor-only
RUN CGO_ENABLED=0 go build -o /xz
# Final step
FROM alpine
RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
RUN apk add --update tzdata
RUN rm -rf /var/cache/apk/*
COPY --from=build /xz /home/
ENV TZ=Europe/Paris
WORKDIR /home
ENTRYPOINT ./xz
EXPOSE 8080
