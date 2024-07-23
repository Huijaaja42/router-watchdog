FROM alpine:latest

LABEL org.opencontainers.image.title="Router Watchdog"
LABEL org.opencontainers.image.description="Watchdog for restarting the router."
LABEL org.opencontainers.image.authors="Christian Kovanen <christian@intor.fi>"

RUN apk --no-cache add mosquitto-clients

ADD script.sh script.sh
RUN chmod +x script.sh
RUN echo 0 > /root/counter
RUN echo "* * * * * /script.sh" > crontab.txt
RUN crontab crontab.txt
RUN rm crontab.txt

CMD ["/usr/sbin/crond", "-f"]

