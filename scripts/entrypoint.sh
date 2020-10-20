#!/bin/sh

set -e

python3 /app/scripts/wait.py

if [ ! -f /deploy/touched ]; then
    python3 /app/scripts/entrypoint.py
    touch /deploy/touched
fi

cd /opt/jans/jetty/scim
exec java \
    -server \
    -XX:+DisableExplicitGC \
    -XX:+UseContainerSupport \
    -XX:MaxRAMPercentage=$CLOUD_NATIVE_MAX_RAM_PERCENTAGE \
    -Djans.base=/etc/jans \
    -Dserver.base=/opt/jans/jetty/scim \
    -Dlog.base=/opt/jans/jetty/scim \
    -Djava.io.tmpdir=/tmp \
    -Dpython.home=/opt/jython \
    ${CLOUD_NATIVE_JAVA_OPTIONS} \
    -jar /opt/jetty/start.jar
