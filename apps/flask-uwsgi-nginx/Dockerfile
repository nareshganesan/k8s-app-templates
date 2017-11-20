FROM alpine:3.5
MAINTAINER Naresh Ganesan <nareshkumarganesan@gmail.com>

# working directory
WORKDIR /tmp

# copy your app code
COPY . .

# basic flask environment
RUN apk add --no-cache bash git nginx \
    uwsgi uwsgi-python py2-pip \
    curl openssl supervisor \
    && chmod u+rx,g+rx,o+rx,a-w /tmp/docker-entrypoint.bash \
    && mkdir -p /opt/ssl \
    && chown -R nginx:nginx /opt/ \
    && pip2 install --upgrade pip \
    && pip2 install -r requirements.txt \
    && rm -rf /var/cache/apk/*

# expose server port
EXPOSE 80

# create log directory
RUN mkdir logs

# create nginx config
RUN mkdir -p /etc/nginx/
RUN rm /etc/nginx/nginx.conf
RUN cp nginx/nginx.conf /etc/nginx/

# Make NGINX run on foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# supervisord config
RUN rm /etc/supervisord.conf
RUN ln -s supervisord/supervisord.conf /etc/

# Use the following script only if you need self signed ssl cert to be generated everytime
# ENTRYPOINT ["/tmp/docker-entrypoint.bash"]

CMD ["supervisord", "-c", "/tmp/supervisord/supervisord.conf", "-n"]
