FROM openjdk:8-jre-alpine
# Create a directory to store the application
RUN mkdir /app
ENV APP_HOME=/app/
WORKDIR $APP_HOME
# Copy the built application to the container
COPY build/libs/*.jar /app/app.jar
# Expose port 8080
EXPOSE 8080
# Run the application
CMD ["java", "-XX:NativeMemoryTracking=detail", "-jar", "/app/app.jar"]