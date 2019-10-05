FROM golang:1.13-rc

WORKDIR /go/src/
RUN git clone https://github.com/gohugoio/hugo.git
WORKDIR /go/src/hugo
RUN go install --tags extended

RUN go get github.com/bgadrian/medium-to-hugo

RUN useradd -ms /bin/bash app
USER app

WORKDIR /go/src/app
COPY . .
