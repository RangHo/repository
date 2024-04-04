#!/bin/sh

REPOSITORY="https://github.com/RangHo/android-hello-world.git"
REF="f82431920a5206b6e40bc9b5e52dce693162fc74"

# Clone the repository
git clone "$REPOSITORY" repo
cd repo
git checkout "$REF"

# Build the project
./gradlew build

