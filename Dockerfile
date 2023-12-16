# Base Image
FROM nginx:alpine

# Eigenen Web-Content in Container kopieren
COPY ./docs/* /usr/share/nginx/html/
