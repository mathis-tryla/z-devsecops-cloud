#!/bin/sh

# exit immediately if one line after the one below fail
set -e

# run the java application through the app.jar generated in the dockerfile
exec java $JAVA_OPTS -jar /app.jar "$@"