FROM openjdk:8
ENV airAPP airports-assembly-1.0.1.jar
ADD $airAPP  /opt/$airAPP
ENTRYPOINT ["/bin/bash", "-c", "java -jar /opt/$airAPP"]

