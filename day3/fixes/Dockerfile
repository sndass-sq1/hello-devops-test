# Current base image, patched at build time, with security headers
FROM nginx:stable-alpine
RUN apk upgrade --no-cache
COPY nginx/security-headers.conf /etc/nginx/conf.d/security-headers.conf
COPY site/ /usr/share/nginx/html/
EXPOSE 80
