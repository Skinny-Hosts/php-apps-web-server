# @version 4.0.0
# Configures NGINX .

FROM nginx:1.19.1-alpine
LABEL maintainer="marcosfreitas@c4network.com.br"

#RUN apk add --no-cache shadow &&\
#    usermod -u 1000 nginx

#USER nginx

EXPOSE 80
# @todo not prepared to work with SSL connections yet
EXPOSE 443

RUN cd / &&\
    wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh &&\
    chmod +x wait-for-it.sh

RUN rm /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf

# From the context of this Dockerfile
ADD nginx.conf /etc/nginx/nginx.conf

#ADD conf/vhost-app.conf /etc/nginx/sites-available/app

# @bug permission bug
#RUN mkdir -p /etc/nginx/sites-enabled &&\
#    mkdir -p /etc/nginx/templates &&\
#    chmod 751 -R /etc/nginx &&\
#    ls -l /etc/nginx/ &&\
#    ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app

# @bug problem with relative paths
#RUN rm -rf /var/www/html
#VOLUME /../../www /var/www/html
#VOLUME /../..//.docker/nginx/templates /etc/nginx/templates

# @todo make entrypoints and custon configurations

CMD ["nginx", "-g", "daemon off;"]