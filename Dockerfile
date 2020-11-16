FROM golang:1.13-rc

RUN apt update && apt install vim -y && rm -rf /var/lib/apt/lists/*

WORKDIR /go/src/
RUN git clone https://github.com/gohugoio/hugo.git
RUN git clone https://github.com/bgadrian/medium-to-hugo.git
WORKDIR /go/src/hugo
RUN go install --tags extended

WORKDIR /go/src/medium-to-hugo
RUN go install

RUN useradd -ms /bin/bash app
USER app

WORKDIR /go/src/app
COPY . .
