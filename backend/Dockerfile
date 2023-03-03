ARG JAR_FILE="default"

FROM eclipse-temurin:19-jre-ubi9-minimal

ARG JAR_FILE

#ADD target/*.jar /app.jar
ADD ${ JAR_FILE } /app.jar

EXPOSE 8080

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
