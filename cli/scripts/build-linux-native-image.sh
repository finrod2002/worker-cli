#!/bin/bash
set -e
echo "version=$BUILD_VERSION" >> ./cli/src/main/resources/values.properties
#./gradlew --info --stacktrace jar shadowJar nativeImage test
./gradlew --info --stacktrace jar shadowJar nativeImage
