FROM openjdk:8
ENV AppFile airports-assembly-1.2.0.jar
ADD $AppFile  /opt/$AppFile
ENTRYPOINT ["/bin/bash", "-c", "java -jar /opt/$AppFile"]

