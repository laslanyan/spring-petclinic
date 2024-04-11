FROM openjdk:17-jdk

WORKDIR /app

COPY /target/spring-petclinic-4.2.0-SNAPSHOT.jar /app/spring-petclinic-4.2.0-SNAPSHOT.jar

EXPOSE 8080 

CMD [ "/usr/bin/java", "-jar", "/app/spring-petclinic-4.2.0-SNAPSHOT.jar" ]