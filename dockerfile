# Verwende das offizielle OpenJDK 8 Basisimage
#FROM openjdk:21-alpine

FROM amazoncorretto:23-jdk

# Installiere tmux
#RUN apk add --no-cache tmux bash

RUN yum install -y tmux bash dos2unix

# Setze eine Umgebungsvariable
ENV XMS=128M

# Setze eine Umgebungsvariable
ENV XMX=128M

# Setze eine Umgebungsvariable
ENV AUTOUPDATE=false

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere die JAR-Datei deiner Anwendung in das Arbeitsverzeichnis
COPY ./CloudNet/* .
COPY ./start.sh .
COPY ./entrypoint.sh /

RUN dos2unix ./start.sh
RUN dos2unix /entrypoint.sh

# Setze die Ausführungsrechte für die Startdatei
RUN chmod +x start.sh
RUN chmod +x /entrypoint.sh

# Definiere den Befehl zum Ausführen des Entry-Point-Skripts

CMD ["bash"]

ENTRYPOINT ["/entrypoint.sh"]