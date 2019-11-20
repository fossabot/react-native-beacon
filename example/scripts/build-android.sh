#!/bin/bash

set -e

# Accept the Android SDK license agreements
echo y | sdkmanager "platforms;android-28" >/dev/null
echo y | sdkmanager "platform-tools" >/dev/null
echo y | sdkmanager "build-tools;28.0.3" >/dev/null

# Go to android path
cd android

# Remove build folder
rm -rf app/build

# Clean
./gradlew clean

# Remove old keykeystore if exist
rm -rf app/release.keystore

# Generate release keystore
keytool \
  -v \
  -genkey \
  -keystore app/release.keystore \
  -storepass android \
  -alias androidreleasekey \
  -keypass android \
  -keysize 1024 \
  -validity 14000 \
  -dname 'CN=Android Debug,O=Android,C=US'

keytool \
  -importkeystore \
  -srckeystore \
  app/release.keystore \
  -destkeystore \
  app/release.keystore \
  -deststoretype \
  pkcs12

# Run release build
./gradlew assembleRelease --console=plain -S