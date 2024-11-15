#!/bin/sh

################################################################################

# Version constants
REVANCED_CLI_VERSION="4.6.0"
REVANCED_PATCHES_VERSION="4.6.0"
REVANCED_INTEGRATIONS_VERSION="1.7.0"

PIXIV_VERSION="6.103.0"

################################################################################

echo "Downloading ReVanced utilities..."
curl -Lo revanced-cli.jar \
     "https://github.com/ReVanced/revanced-cli/releases/download/v${REVANCED_CLI_VERSION}/revanced-cli-${REVANCED_CLI_VERSION}-all.jar"
curl -Lo revanced-patches.jar \
     "https://github.com/ReVanced/revanced-patches/releases/download/v${REVANCED_PATCHES_VERSION}/revanced-patches-${REVANCED_PATCHES_VERSION}.jar"
curl -Lo revanced-integrations.jar \
     "https://github.com/ReVanced/revanced-integrations/releases/download/v${REVANCED_INTEGRATIONS_VERSION}/revanced-integrations-${REVANCED_INTEGRATIONS_VERSION}.apk"

echo "Downloading official Pixiv APK..."
npm install -g apkmirror-downloader
cat <<EOF >download.js
import { APKMirrorDownloader } from 'apkmirror-downloader';

const downloader = new APKMirrorDownloader({ 'overwrite': true });

downloader.download({
    "org": "pixiv-inc",
    "id": "pixiv",
    "version": "${PIXIV_VERSION}",
    "outFile": "pixiv.apk"
});
EOF
node download.js

echo "Patching Pixiv APK..."
cat <<EOF >options.json
[
    {
        "patchName" : "Change package name",
        "options" : [{
            "key" : "packageName",
            "value" : "Default"
        }]
    }
]
EOF
java -jar revanced-cli.jar patch \
     --patch-bundle revanced-patches.jar \
     --merge revanced-integrations.jar \
     --options options.json \
     --include "Change package name" \
     --include "Hide ads" \
     pixiv.apk

mv pixiv-patched.apk jp.pxv.android.apk
