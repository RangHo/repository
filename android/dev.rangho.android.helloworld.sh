#!/bin/sh

REPOSITORY="https://github.com/RangHo/android-hello-world.git"
REF="f82431920a5206b6e40bc9b5e52dce693162fc74"

# Clone the repository
git clone "$REPOSITORY" repo
cd repo
git checkout "$REF"

# Build the project
./gradlew build

# Copy the APK to regular location
cp app/build/outputs/apk/debug/app-debug.apk ../dev.rangho.android.helloworld.apk
