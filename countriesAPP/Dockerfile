FROM openjdk:8
ENV AppFile countries-assembly-1.0.1.jar
ADD $AppFile  /opt/$AppFile
ENTRYPOINT ["/bin/bash", "-c", "java -jar /opt/$AppFile"]


