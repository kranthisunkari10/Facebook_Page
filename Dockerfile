FROM ubuntu:latest AS buildAgent

WORKDIR /app

RUN apt-get update && \
	apt-get install -y openjdk-11-jdk maven && \
	apt-get clean

COPY . .

RUN mvn clean package -DskipTests

#############
FROM tomcat:jre21

WORKDIR webapps

COPY --from=buildAgent /app/target/*.war .

RUN rm -rf ROOT && mv *.war ROOT.war

EXPOSE 8080


