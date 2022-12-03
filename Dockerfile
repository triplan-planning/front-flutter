FROM cirrusci/flutter:stable

RUN flutter doctor
RUN flutter config --enable-web

COPY build/web /usr/share/nginx/html