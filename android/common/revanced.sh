#!/bin/sh

# This script automatically downloads APK files from APKMirror and patches them
# using ReVanced patchers.

# Usage:
#     ./revanced.sh <org> <repo> <version> <ReVacned CLI arguments>...

################################################################################
# Constants
################################################################################

readonly APKMD_VERSION="2.0.8"
readonly REVANCED_CLI_VERSION="5.0.0"
readonly REVANCED_PATCHES_VERSION="5.5.1"

################################################################################
# Functions
################################################################################

download_apkmd() {
    if ! [ -f "apkmd" ]; then
        echo "Downloading APKMirror Downloader..."
        curl -SL "https://github.com/tanishqmanuja/apkmirror-downloader/releases/download/v${APKMD_VERSION}/apkmd" -o "apkmd"
    fi

    if ! [ -x "apkmd" ]; then
        echo "Making APKMirror Downloader executable..."
        chmod +x "apkmd"
    fi

    echo "APKMirror Downloader is ready."
}

download_revanced_cli() {
    if ! [ -f "revanced-cli.jar" ]; then
        echo "Downloading ReVanced CLI..."
        curl -SL "https://github.com/ReVanced/revanced-cli/releases/download/v${REVANCED_CLI_VERSION}/revanced-cli-${REVANCED_CLI_VERSION}-all.jar" -o "revanced-cli.jar"
    fi

    echo "ReVanced CLI is ready."
}

download_revanced_patches() {
    if ! [ -f "revanced-patches.rvp" ]; then
        echo "Downloading ReVanced patches..."
        curl -SL "https://github.com/ReVanced/revanced-patches/releases/download/v${REVANCED_PATCHES_VERSION}/patches-${REVANCED_PATCHES_VERSION}.rvp" -o "revanced-patches.rvp"
    fi

    echo "ReVanced Patches are ready."
}

download_apk() {
    ORG="$1"
    REPO="$2"
    VERSION="$3"

    echo "APK is from ${ORG}/${REPO}, version ${VERSION}."
    cat <<EOF >apps.json
{
    "apps": [
        {
            "org": "${ORG}",
            "repo": "${REPO}",
            "version": "${VERSION}",
            "outFile": "original.apk"
        }
    ]
}
EOF

    ./apkmd apps.json
}

################################################################################
# Entrypoint
################################################################################

# Get the arguments
ORG="$1"
REPO="$2"
VERSION="$3"
shift 3

# Make sure we have all the required tools
download_apkmd
download_revanced_cli
download_revanced_patches

# Download the APK
download_apk "${ORG}" "${REPO}" "${VERSION}"

# Patch the APK
java -jar revanced-cli.jar patch --patches=revanced-patches.rvp original.apk "$@"
