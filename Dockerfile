FROM nginx
LABEL maintainer="Elliot Saba <staticfloat@gmail.com>, Valder Gallo <valergallo@gmail.com>, Bruno Zell <bruno.zzell@gmail.com>"

VOLUME /etc/letsencrypt
EXPOSE 80
EXPOSE 443

# Do this apt/pip stuff all in one RUN command to avoid creating large
# intermediate layers on non-squashable docker installs
RUN apt update && \
    apt install -y python3 python3-pip procps && pip3 install -U cffi certbot

# Copy in scripts for certbot
COPY ./scripts/ /scripts
RUN chmod +x /scripts/*.sh

# Add /scripts/startup directory to source more startup scripts
RUN mkdir -p /scripts/startup

# Copy in default nginx configuration (which just forwards ACME requests to
# certbot, or redirects to HTTPS, but has no HTTPS configurations by default).
RUN rm -f /etc/nginx/conf.d/*
COPY nginx_conf.d/ /etc/nginx/conf.d/

ENTRYPOINT []
CMD ["/bin/bash", "/scripts/entrypoint.sh"]
