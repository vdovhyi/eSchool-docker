FROM amazoncorretto:latest
RUN \
# Update
yum update -y
COPY ./target/eschool.jar ./app/eschool.jar
COPY ./docker_backend/application.properties ./app/application.properties
WORKDIR ./app
EXPOSE 8080
CMD ["java", "-jar", "eschool.jar", "application.properties"]