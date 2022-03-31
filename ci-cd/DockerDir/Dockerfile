FROM alpine:3.9
LABEL MAINTAINER="Doron Brand"
RUN apk update && \
    apk upgrade && \
    apk add --no-cache python3 py3-pip

COPY . /opt/app
WORKDIR /opt/app
RUN pip3 install -r requirements.txt

CMD [ "python3", "./app.py" ]
