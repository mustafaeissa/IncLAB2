FROM openjdk:8
ENV AirFile airports-assembly-1.1.0.jar
ADD $AirFile  /opt/$AirFile
ENTRYPOINT ["/bin/bash", "-c", "java -jar /opt/$AirFile"]

