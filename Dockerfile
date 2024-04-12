# Use a smaller base image for the builder stage
FROM alpine:latest AS builder

# Install openjdk17
RUN apk --no-cache add openjdk17

# Set the working directory
WORKDIR /tmp

# Copy the Maven project files
COPY ./ ./

# Build the project
RUN ./mvnw clean package 

# Use a smaller base image for the final stage
FROM alpine:latest

# Install openjdk17-jre-headless
RUN apk --no-cache add openjdk17-jre-headless

# Set the working directory
WORKDIR /home

# Copy the JAR file from the builder stage
COPY --from=builder /tmp/target/spring-*.jar ./spring-petclinic-app.jar

# Expose port 8080
EXPOSE 8080

# Run the application
CMD [ "/usr/bin/java", "-jar", "/home/spring-petclinic-app.jar" ]
