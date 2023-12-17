# Offizielles Base Image für Webserver "nginx", siehe https://hub.docker.com/_/nginx/
FROM nginx:stable-alpine3.17-slim

# Der mit der folgenden Zeile definierte Maintainer wird z.B. mit dem Befehl
# docker image inspect <imageName> ausgegeben.
LABEL maintainer="MDecker-MobileComputing"

# Eigenen Web-Content in Container kopieren
COPY ./docs/* /usr/share/nginx/html/
