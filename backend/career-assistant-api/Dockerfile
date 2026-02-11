# Stage 1: Build
FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app

# The context is now the subfolder, so pom.xml is in the current directory
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy src directly
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter

USER spring:spring

# The jar will be in /app/target/ because WORKDIR was /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]