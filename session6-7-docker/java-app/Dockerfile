FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY HelloWorldServer.java .

RUN javac HelloWorldServer.java

EXPOSE 8080

CMD ["java", "HelloWorldServer"]
