FROM ubuntu:xenial
USER root

ENV APR_FILE apr-1.6.3
ENV APRU_FILE apr-util-1.6.1
ENV HTTP_FILE httpd-2.4.33
ENV PHP_FILE php-7.2.5
ENV HTTP_PREFIX /usr/local/apache
ENV TMP_DIR /tmp

# install dependancies for apr, httpd, and php7

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     libexpat1-dev \
     libpcre++-dev \
     libxml2-dev \
     make \
     gcc \
     wget \
  && rm -rf /var/lib/apt/lists/* 

WORKDIR ${TMP_DIR}

# grab and extract apr

RUN wget http://www-us.apache.org/dist//apr/${APR_FILE}.tar.gz \ 
  && tar -zxvf ${APR_FILE}.tar.gz \
  && rm -f ${APR_FILE}.tar.gz

WORKDIR ${TMP_DIR}/${APR_FILE}

# configure make, and install apr

RUN ./configure --prefix=${HTTP_PREFIX} \
  && make && make install

WORKDIR ${TMP_DIR} 

# grab apr and extract

RUN wget http://www-us.apache.org/dist//apr/${APRU_FILE}.tar.gz \
  && tar -zxvf ${APRU_FILE}.tar.gz \
  && rm -f ${APRU_FILE}.tar.gz

WORKDIR ${TMP_DIR}/${APRU_FILE}

# configure make and install apru

RUN ./configure --prefix=${HTTP_PREFIX} --with-apr=${HTTP_PREFIX}/bin/apr-1-config \
  && make && make install

WORKDIR ${TMP_DIR} 

# grab and extract apache

RUN wget --no-check-certificate https://archive.apache.org/dist/httpd/${HTTP_FILE}.tar.gz \
  && tar -zxvf ${HTTP_FILE}.tar.gz \
  && rm -f ${HTTP_FILE}.tar.gz

COPY configure-http.sh ${TMP_DIR}/${HTTP_FILE}

WORKDIR ${TMP_DIR}/${HTTP_FILE}

# configure make and install apache

RUN ./configure-http.sh \
  && make &&  make install

WORKDIR ${TMP_DIR} 

# grab php7 and extract it

RUN wget http://us1.php.net/distributions/${PHP_FILE}.tar.gz \
  && tar -zxvf ${PHP_FILE}.tar.gz \
  && rm -f ${PHP_FILE}.tar.gz

COPY configure-php.sh ${TMP_DIR}/${PHP_FILE}

WORKDIR ${TMP_DIR}/${PHP_FILE}

# configure make and install php with php7 module for apache

RUN ./configure-php.sh \
  && make && make install

# cleanup packages that are not needed anymore

RUN apt-get purge -y --auto-remove \
  gcc \
  make \
  wget \
  && rm -rf /var/tmp/* \
  && rm -rf /tmp/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/apache/logs/access_log \
	&& ln -sf /dev/stderr /usr/local/apache/logs/error_log

COPY start-apache /usr/local/bin 

RUN chmod +x /usr/local/bin/start-apache

WORKDIR ${HTTP_PREFIX}/conf

COPY httpd.conf httpd.conf

WORKDIR /

EXPOSE 80

CMD ["start-apache"]
