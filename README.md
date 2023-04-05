# Industrial IoT Gateway using MING with HiveMQ and balena

This is a reference architecture to run on your IIoT Edge Gateway with HiveMQ MQTT broker on balena. 

The example application is reading from Modbus and OPC UA sensors using the MING stack (MQTT, InfluxDB, NodeRED and Grafana) to use the advantages of the Edge Computing to digitalize a factory. In future examples we are going to use IIoT Edge Gateways with HiveMQ and balena to add a UNS (Unified Name Space) for data modeling and MQTT Sparkplug B to format the data being sent over MQTT.


## Deploy the code

Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/mpous/hivemq4-ming)

Follow instructions, click Add a Device and flash an SD card with that OS image dowloaded from balenaCloud. Enjoy the magic 🌟Over-The-Air🌟!

## Configure nodeRED

These variables you can set them in the balenaCloud `Device Variables` tab for the device (or globally for the whole application). If you would like to change your login credentials feel free to update these variables.

Variable Name | Value | Description | Default
------------ | ------------- | ------------- | -------------
**`USERNAME`** | `STRING` | Define a new username | `balena`
**`PASSWORD`** | `STRING` | Define a new password | `balena`
**`ENCRIPTION_KEY`** | `STRING` | Define a new key to encrypt nodeRED system | `balena`


## Configure the HiveMQ MQTT broker

These variables you can set them in the balenaCloud `Device Variables` tab for the device (or globally for the whole application). None of them are mandatory and the MQTT broker in the edge might work without any variable defined.

Variable Name | Value | Description | Default
------------ | ------------- | ------------- | -------------
**`HIVEMQ_BRIDGE_EXTENSION`** | `boolean` | Enable bridge extension and delete the `DISABLED` file on the bridge-extension folder | `false`
**`HIVEMQ_CONNECTION_ENABLED`** | `boolean` | Enables to change the bridge-extension.xml file with the `connection` tag. | `false`
**`HIVEMQ_CONNECTION_CONFIGURATION`** | `STRING (XML)` | Connection tag XML definition. | ```<connection><static><host>your-host-address</host><port>your-port</port></static></connection>```
**`HIVEMQ_AUTHENTICATION_ENABLED`** | `boolean` | Enables to change the bridge-extension.xml file to add the `authentication` tag. | `false`
**`HIVEMQ_AUTHENTICATION_CONFIGURATION`** | `STRING (XML)` | Authentication tag XML definition. | ```<authentication><mqtt-simple-authentication><username>your-username</username><password>your-password</password></mqtt-simple-authentication></authentication>```
**`HIVEMQ_TOPICS_CONFIGURATION`** | `STRING (XML)` | Topics tag XML definition on the bridge-extension.xml file. | ```<topics><topic><filter>plant1/compressors</filter></topic></topics>```
**`HIVEMQ_LICENSE`** | `STRING` | Your license file cntent in one unique line separated by "|". Automatically the system will generate a `license.lic` file with the base64 content from this variable. | 
**`HIVEMQ_REST_API_ENABLED`** | `boolean` | Enables to change the config.xml file with the `rest-api` tag. | `false`
**`HIVEMQ_REST_API_CONFIGURATION`** | `STRING (XML)` | REST API tag XML definition on the config.xml file. | ```<rest-api><enabled>true</enabled><listeners><http><port>8888</port><bind-address>0.0.0.0</bind-address></http></listeners></rest-api>```


## Log in

The MING services are exposed in different ports. On the default configuration they use the default port and credentials to access them. Check the documentation for each of them to know how to change them using variables.

|Service|Port|Username|Password|
|:--|---|---|---|
|HiveMQ|8080 (http)|admin|hivemq|
|NodeRED|80 (http)|balena|balena|
|Grafana|3000 (http)|admin|admin|


## Attribution

- This is in part working thanks of the work of [Kudzai Manditereza](https://github.com/kmanditereza) from HiveMQ and Marc Pous from balena.io.

## Troubleshooting

If you detect any issue using this block, feel free to contact us at the [forums.balena.io](https://forums.balena.io).

