FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY target/audora-service-discovery-*.jar app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]
