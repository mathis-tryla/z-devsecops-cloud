FROM eclipse-temurin:19-jre-ubi9-minimal

#ADD target/*.jar /app.jar
ARG JAR

ADD ${JAR} /app.jar

ENV VAR_JAR=$JAR

EXPOSE 8080

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
