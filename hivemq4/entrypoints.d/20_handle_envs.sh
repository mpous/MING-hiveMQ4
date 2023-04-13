#!/usr/bin/env bash

# Decode license and put file if present
#if [[ -n "${HIVEMQ_LICENSE}" ]]; then
#    echo >&3 "Decoding license..."
#    echo "${HIVEMQ_LICENSE}" | base64 -d > /opt/hivemq/license/license.lic
#    #echo "${HIVEMQ_LICENSE}" > /opt/hivemq/license/license.lic
#fi

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

# BRIDGE EXTENSION
# Enable bridge extensions if you are going to use the HiveMQ Bridge Extension
if [[ "${HIVEMQ_BRIDGE_EXTENSION}" == "true" ]]; then
    echo "Enabling the bridge extension"
    rm /opt/hivemq/extensions/hivemq-bridge-extension/DISABLED || true
fi


# CONNECTION
# Cloud connection configuration to have a bridge extension connection between the Edge Broker and the Cloud Broker
if [[ -n "${HIVEMQ_HOST_URL}" ]]; then
  echo "Enabling connection (host) in bridge-configuration.xml from balenaCloud Device Variables."
  sed -i "s|HIVEMQ_HOST_URL|${HIVEMQ_HOST_URL}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi

if [[ -n "${HIVEMQ_HOST_PORT}" ]]; then
  echo "Enabling connection (port) in bridge-configuration.xml from balenaCloud Device Variables."
  sed -i "s|HIVEMQ_HOST_PORT|${HIVEMQ_HOST_PORT}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi


# AUTHENTICATION
# MQTT simple authentication for the bridge extension. edge --> cloud connection
if [[ -n "${HIVEMQ_HOST_USERNAME}" ]]; then
  echo "Enabling AUTHENTICATION (username) in bridge-configuration.xml from balenaCloud Device Variables."
  sed -i "s|HIVEMQ_HOST_USERNAME|${HIVEMQ_HOST_USERNAME}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi

if [[ -n "${HIVEMQ_HOST_PASSWORD}" ]]; then
  echo "Enabling AUTHENTICATION (password) in bridge-configuration.xml from balenaCloud Device Variables."
  sed -i "s|HIVEMQ_HOST_PASSWORD|${HIVEMQ_HOST_PASSWORD}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi



# TLS enabled
#
# <tls>
#   <enabled>true</enabled>
#   <cipher-suites>
#     <cipher-suite>TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384</cipher-suite>
#     <cipher-suite>TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256</cipher-suite>
#     <cipher-suite>TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256</cipher-suite>
#     <cipher-suite>TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384</cipher-suite>
#     <cipher-suite>TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA</cipher-suite>
#     <cipher-suite>TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA</cipher-suite>
#     <cipher-suite>TLS_RSA_WITH_AES_128_GCM_SHA256</cipher-suite>
#     <cipher-suite>TLS_RSA_WITH_AES_128_CBC_SHA</cipher-suite>
#     <cipher-suite>TLS_RSA_WITH_AES_256_CBC_SHA</cipher-suite>
#   </cipher-suites>
#   <protocols>
#     <protocol>TLSv1.2</protocol>
#   </protocols>
# </tls>
#
if [[ "${HIVEMQ_TLS_ENABLED}" == "true" ]]; then
  echo "Enabling TOPICS in bridge-configuration.xml from balenaCloud Device Variables."
  HIVEMQ_TLS="<tls><enabled>true</enabled><cipher-suites><cipher-suite>TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384</cipher-suite><cipher-suite>TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256</cipher-suite><cipher-suite>TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256</cipher-suite><cipher-suite>TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384</cipher-suite><cipher-suite>TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA</cipher-suite><cipher-suite>TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA</cipher-suite><cipher-suite>TLS_RSA_WITH_AES_128_GCM_SHA256</cipher-suite><cipher-suite>TLS_RSA_WITH_AES_128_CBC_SHA</cipher-suite><cipher-suite>TLS_RSA_WITH_AES_256_CBC_SHA</cipher-suite></cipher-suites><protocols><protocol>TLSv1.2</protocol></protocols></tls>"
  sed -i "s|<!-- TLS -->|${HIVEMQ_TLS}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi

# Topics and filters configuration (example below)
#
#     <filter>iiot/lab/cloud</filter>
#     <filter>iiot/lab/webapp/status</filter>
#
if [[ -n "${HIVEMQ_TOPICS_CONFIGURATION}" ]]; then
  echo "Enabling TOPICS in bridge-configuration.xml from balenaCloud Device Variables."
  HIVEMQ_TOPICS_CONFIGURATION="${HIVEMQ_TOPICS_CONFIGURATION//$'\n'/}"
  sed -i "s|<!-- TOPICS -->|${HIVEMQ_TOPICS_CONFIGURATION}|" /opt/hivemq/extensions/hivemq-bridge-extension/bridge-configuration.xml
fi

echo >&3 "setting bind address to ${HIVEMQ_BIND_ADDRESS}"