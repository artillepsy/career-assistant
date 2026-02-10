# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-25 AS build

WORKDIR /app

# Copy pom files for dependency resolution
COPY pom.xml .
COPY backend/career-assistant-api/pom.xml backend/career-assistant-api/

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY backend/career-assistant-api/src backend/career-assistant-api/src

# Build the application
RUN mvn clean package -DskipTests -f backend/career-assistant-api/pom.xml

# Stage 2: Create runtime image
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the built artifact from build stage
COPY --from=build /app/backend/career-assistant-api/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
