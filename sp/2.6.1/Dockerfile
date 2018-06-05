FROM unicon/shibboleth-sp@sha256:6969edc938243c26f0485bf40ce006f4ef763481f57dd2c9f364237f1243894b

RUN yum -y install php mod_ssl mod_substitute mod_proxy_ajp

COPY etc-shibboleth /etc/shibboleth/
COPY etc-httpd/ /etc/httpd/
COPY var-www-html/ /var/www/html/
