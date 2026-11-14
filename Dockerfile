# Day 2: package the site into a container image
FROM nginx:stable-alpine
COPY site/ /usr/share/nginx/html/
EXPOSE 80
