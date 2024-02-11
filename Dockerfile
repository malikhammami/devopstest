# Utilisez une image de base JDK 8
FROM openjdk:8-jdk-alpine

# Copiez le JAR depuis Nexus vers le conteneur
ARG NEXUS_URL=http://192.168.1.222:8081/repository/maven-releases/tn/esprit/rh/achat/1.0/
ARG JAR_FILE=achat-1.0.jar

ADD ${NEXUS_URL}${JAR_FILE} springachat.jar

# Exposez le port sur lequel votre application Spring Boot écoute
EXPOSE 8082

ENTRYPOINT ["java","-jar","/springachat.jar"]
