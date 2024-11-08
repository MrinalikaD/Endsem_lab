# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code into the container
COPY src ./src

# Build the application, skipping tests to speed up the build
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:17-jdk-slim AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the builder stage to the runtime stage
COPY --from=builder /app/target/*.jar app.jar


EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8081"]


