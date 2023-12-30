# Offizielles Base Image für Webserver "nginx", siehe https://hub.docker.com/_/nginx/
# Doku zum Befehl: https://docs.docker.com/engine/reference/builder/#from
FROM nginx:stable-alpine3.17-slim


# Der mit der folgenden Zeile definierte Maintainer wird z.B. mit dem Befehl
# docker image inspect <imageName> ausgegeben.
# Doku zum Befehl: https://docs.docker.com/engine/reference/builder/#label
LABEL maintainer="MDecker-MobileComputing"


# Eigenen Web-Content in Container kopieren.
# Doku zum Befehl: https://docs.docker.com/engine/reference/builder/#copy
COPY ./docs/* /usr/share/nginx/html/


# Zwei Befehle während Erstellung Container ausführen.
# Doku zum Befehl: https://docs.docker.com/engine/reference/builder/#run
# Befehl "apk update" : Paketlisten aktualisieren
# Befehl "apk add joe": Paket "joe" (Texteditor) installieren
# Wenn dieser Schritt fehlschlägt wegen Netzwerkverbindungsproblemen,
# dann muss evtl. die DNS-Einstellung vom Docker-Daemon angepasst werden,
# siehe https://forums.docker.com/t/docker-build-with-alpine-fails-to-run-apk/77838/4
RUN apk update
RUN apk add joe

EXPOSE 80

