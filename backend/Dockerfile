FROM eclipse-temurin:19-jre-ubi9-minimal

ADD target/*.jar /app.jar

EXPOSE 8080

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
