FROM cirrusci/flutter:stable AS build-env

RUN flutter doctor
RUN flutter config --enable-web


# Copy files to container and build
USER root
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Stage 2 - Create the run-time image
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html