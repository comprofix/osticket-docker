FROM wyveo/nginx-php-fpm:php80
LABEL Matthew McKinnon <support@comprofix.com>


ARG OSTICKET_RELEASE
ARG URL
ENV DEBIAN_FRONTEND noninteractive

RUN echo "**** install packages ****"
RUN apt-get update  
#RUN apt-get upgrade --yes --no-install-recommends
RUN apt-get install unzip curl vim mariadb-client php8.0-imap php8.0-apcu cron --yes --no-install-recommends
RUN apt-get clean
RUN crontab -l | { cat; echo "*/2 * * * * php /var/www/html/api/cron.php > /dev/null 2>&1"; } | crontab -
RUN rm -rf /var/lib/apt/lists/* 
RUN echo "**** Downloading Invoice Ninja ****"
RUN if [ -z ${OSTICKET_RELEASE+x} ]; then \
      OSTICKET_RELEASE=$(curl -sX GET "https://api.github.com/repos/osticket/osticket/releases/latest" | \
      awk '/tag_name/{print $4;exit}' FS='[""]'); \
    fi && \
    URL="https://github.com/osTicket/osTicket/releases/download/${OSTICKET_RELEASE}/osTicket-${OSTICKET_RELEASE}.zip" && \
    curl -o /tmp/osticket.zip -L "${URL}"
RUN mkdir -p /var/www/
RUN unzip -q -o /tmp/osticket.zip  "upload/*" -d /var/www/
RUN mv /var/www/upload /var/www/html
RUN chown -R nginx:nginx /var/www/html/
RUN usermod -d /var/www/html/ nginx
RUN rm /tmp/osticket.zip

WORKDIR /var/www/html

COPY root/ /
RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/start.sh"]
