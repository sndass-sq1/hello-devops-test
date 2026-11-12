# An old base image nobody has updated in years
FROM nginx:1.19
COPY site/ /usr/share/nginx/html/
EXPOSE 80
