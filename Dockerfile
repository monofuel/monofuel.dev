FROM golang:1.18-rc

RUN apt update && apt install vim -y && rm -rf /var/lib/apt/lists/*

WORKDIR /go/src/
RUN git clone https://github.com/gohugoio/hugo.git
RUN git clone https://github.com/bgadrian/medium-to-hugo.git
WORKDIR /go/src/hugo
RUN go install --tags extended

WORKDIR /go/src/medium-to-hugo

# https://github.com/bgadrian/medium-to-hugo/issues/6
RUN sed -e '/p.IsComment = doc.Find/s/^/\/\//' -i /go/src/medium-to-hugo/main.go

RUN go install

RUN useradd -ms /bin/bash app
USER app

WORKDIR /go/src/app
COPY . .
