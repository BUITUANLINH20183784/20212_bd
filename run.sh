#!/bin/bash

docker compose up -d
docker cp src spark-master:src
docker cp elasticsearch-hadoop-7.15.1.jar spark-master:elasticsearch-hadoop-7.15.1.jar

docker cp ./rawdata namenode:/
docker exec namenode sh -c "
    hadoop fs -mkdir /data/
    hadoop fs -put /rawdata/ /data/
    hadoop fs -mkdir /data/extracteddata
"

docker exec spark-master sh -c "
    spark/bin/spark-submit --master spark://spark-master:7077 --jars elasticsearch-hadoop-7.15.1.jar --driver-class-path elasticsearch-hadoop-7.15.1.jar src/main.py
"