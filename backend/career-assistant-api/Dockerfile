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

# 1. Create the user FIRST
RUN addgroup -S spring && adduser -S spring -G spring

# 2. Copy the Lambda Adapter and the JAR
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=build /app/target/*.jar app.jar

# 3. Fix ownership so the 'spring' user can create and read the AOT file
RUN chown -R spring:spring /app

# 4. Switch to the user before training
USER spring:spring

# 5. Generate the AOT cache
# Using Output= during build and loading= during runtime
RUN java -XX:AOTCacheOutput=app.aot -Dspring.context.exit=onRefresh -jar app.jar

EXPOSE 8080

# 6. Final Entrypoint
# Include the AOT loading and Tiered compilation flags here
# "-Dspring.aot.enabled=true" - removed
ENTRYPOINT ["java", "-XX:AOTCache=app.aot", "-XX:+TieredCompilation", "-XX:TieredStopAtLevel=1", "-jar", "app.jar"]