# HiveMQ Industrial IoT Gateway with balena

This is a reference architecture to run on your IIoT Edge Gateway HiveMQ MQTT broker with balena reading from Modbus and OPC/UA sensors using UNS (Unified Name Space) and MQTT Sparkplug B. Find the MING stack (MQTT, InfluxDB, NodeRED and Grafana) also running in the edge.


## Deploy the code

### Get the HiveMQ zip file

Go here https://www.hivemq.com/downloads/hivemq/  and download the zip file and add it into the `hivemq` folder.

### Via [Balena Deploy](https://www.balena.io/docs/learn/deploy/deploy-with-balena-button/)

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/mpous/hivemq-iiot-ming-balena)

Follow instructions, click Add a Device and flash an SD card with that OS image dowloaded from balenaCloud. Enjoy the magic 🌟Over-The-Air🌟!




