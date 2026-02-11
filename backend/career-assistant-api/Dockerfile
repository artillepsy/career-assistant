# Stage 1: Build
FROM --platform=$BUILDPLATFORM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# 1. Create a non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring

# 2. Copy the Lambda Adapter and the JAR
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=build /app/target/*.jar app.jar

# 3. Switch to the non-root user
USER spring:spring

EXPOSE 8080

# 4. Standard Entrypoint
ENTRYPOINT ["java", "-jar", "app.jar"]