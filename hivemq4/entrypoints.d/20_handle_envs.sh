#!/usr/bin/env bash

# Decode license and put file if present
#if [[ -n "${HIVEMQ_LICENSE}" ]]; then
#    echo >&3 "Decoding license..."
#    echo "${HIVEMQ_LICENSE}" | base64 -d > /opt/hivemq/license/license.lic
#    #echo "${HIVEMQ_LICENSE}" > /opt/hivemq/license/license.lic
#fi


echo "License?"

if [[ -n "${HIVEMQ_LICENSE}" ]]; then
    echo "Decoding license..."
    
    DELIMITER="|"
    output_file="/opt/hivemq/license/license.lic"

    echo "${HIVEMQ_LICENSE}" | while read -r line; do
      # Split the line by the delimiter and append the results to the output file
      IFS="${DELIMITER}" read -ra arr <<< "$line"
      for i in "${arr[@]}"; do
            echo "$i" >> "$output_file"
      done
    done

fi

# We set the bind address here to ensure HiveMQ uses the correct interface. Defaults to using the container hostname (which should be hardcoded in /etc/hosts)
if [[ -z "${HIVEMQ_BIND_ADDRESS}" ]]; then
    echo >&3 "Getting bind address from container hostname"
    HIVEMQ_BIND_ADDRESS=$(getent hosts ${HOSTNAME} | grep -v 127.0.0.1 | awk '{ print $1 }' | head -n 1)
    export HIVEMQ_BIND_ADDRESS
else
    echo >&3 "HiveMQ bind address was overridden by environment variable (value: ${HIVEMQ_BIND_ADDRESS})"
fi

# Remove allow all extension if applicable
if [[ "${HIVEMQ_ALLOW_ALL_CLIENTS}" != "true" ]]; then
    echo "Disabling allow all extension"
    rm -rf /opt/hivemq/extensions/hivemq-allow-all-extension &>/dev/null || true
fi

if [[ "${HIVEMQ_REST_API_ENABLED}" == "true" ]]; then
  REST_API_ENABLED_CONFIGURATION="<rest-api>
        <enabled>true</enabled>
        <listeners>
            <http>
                <port>8888</port>
                <bind-address>0.0.0.0</bind-address>
            </http>
        </listeners>
    </rest-api>"
  echo "Enabling REST API in config.xml..."
  REST_API_ENABLED_CONFIGURATION="${REST_API_ENABLED_CONFIGURATION//$'\n'/}"
  sed -i "s|<\!--REST-API-CONFIGURATION-->|${REST_API_ENABLED_CONFIGURATION}|" /opt/hivemq/conf/config.xml
fi

# balena version

# Cloud connection configuration to have a connection between the Edge Broker and the Cloud Broker (example below)
#                <connection>  
#                    <static>
#                        <host>157.230.76.185</host>
#                        <port>1883</port> 
#                    </static>
#                </connection>
#
if [[ "${HIVEMQ_CONNECTION_ENABLED}" == "true" ]]; then
  echo "Enabling CLOUD connection in bridge-configuration.xml from balenaCloud Device Variables."
  HIVEMQ_CONNECTION_CONFIGURATION="${HIVEMQ_CONNECTION_CONFIGURATION//$'\n'/}"
  sed -i "s|<\!-- configurable host and port -->|${HIVEMQ_CONNECTION_CONFIGURATION}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi


# Authentication for edge --> cloud connection (example below)
#                 <authentication>
#                    <mqtt-simple-authentication>
#                        <username>a-username</username>
#                        <password>a-user-password</password>
#                    </mqtt-simple-authentication>
#                </authentication>
#
if [[ "${HIVEMQ_AUTHENTICATION_ENABLED}" == "true" ]]; then
  echo "Enabling AUTHENTICATION in bridge-configuration.xml from balenaCloud Device Variables."
  HIVEMQ_AUTHENTICATION_CONFIGURATION="${HIVEMQ_AUTHENTICATION_CONFIGURATION//$'\n'/}"
  sed -i "s|<\!-- authentication -->|${HIVEMQ_AUTHENTICATION_CONFIGURATION}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi


# Topics and filters configuration (example below)
#           <topics> 
#                <topic>
#                    <filter>iiot/lab/cloud</filter>
#                    <filter>iiot/lab/webapp/status</filter>
#                </topic>
#            </topics>
#
if [[ -n "${HIVEMQ_TOPICS_CONFIGURATION}" ]]; then
  echo "Enabling TOPICS in bridge-configuration.xml from balenaCloud Device Variables."
  HIVEMQ_TOPICS_CONFIGURATION="${HIVEMQ_TOPICS_CONFIGURATION//$'\n'/}"
  sed -i "s|<\!-- configurable list of filters -->|${HIVEMQ_TOPICS_CONFIGURATION}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi

echo >&3 "setting bind address to ${HIVEMQ_BIND_ADDRESS}"