# Use a smaller base image for the builder stage
FROM alpine:latest AS builder

# Install openjdk17
RUN apk --no-cache add openjdk17

# Set the working directory
WORKDIR /tmp

# Copy the Maven project files
COPY ./ ./

# Build the project
RUN --mount=type=cache,target=/root/.m2 ./mvnw clean package -DskipTests

# Use an image for final stage
FROM eclipse-temurin:17.0.10_7-jre

# Set the working directory
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /tmp/target/spring-*.jar ./spring-petclinic-v5.jar

# Expose port 8080
EXPOSE 8080

# Run the application
CMD [ "java", "-jar", "/app/spring-petclinic-v5.jar" ]
