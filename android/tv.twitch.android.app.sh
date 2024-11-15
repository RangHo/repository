#!/bin/sh

################################################################################

# Version constants
REVANCED_CLI_VERSION="4.6.0"
REVANCED_PATCHES_VERSION="4.6.0"
REVANCED_INTEGRATIONS_VERSION="1.7.0"

TWITCH_VERSION="16.9.1"

################################################################################

echo "Downloading ReVanced utilities..."
curl -Lo revanced-cli.jar \
     "https://github.com/ReVanced/revanced-cli/releases/download/v${REVANCED_CLI_VERSION}/revanced-cli-${REVANCED_CLI_VERSION}-all.jar"
curl -Lo revanced-patches.jar \
     "https://github.com/ReVanced/revanced-patches/releases/download/v${REVANCED_PATCHES_VERSION}/revanced-patches-${REVANCED_PATCHES_VERSION}.jar"
curl -Lo revanced-integrations.jar \
     "https://github.com/ReVanced/revanced-integrations/releases/download/v${REVANCED_INTEGRATIONS_VERSION}/revanced-integrations-${REVANCED_INTEGRATIONS_VERSION}.apk"

echo "Downloading official Twitch APK..."
npm install -g apkmirror-downloader
cat <<EOF >download.mjs
import { APKMirrorDownloader } from 'apkmirror-downloader';

const downloader = new APKMirrorDownloader({ 'overwrite': true });

downloader.download({
    'org': 'twitch-interactive-inc',
    'id': 'twitch',
    'version': '${TWITCH_VERSION}',
    'outFile': 'twitch.apk'
});
EOF
node download.mjs

echo "Patching Twitch APK..."
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
     --include "Block video ads" \
     --include "Block embedded ads" \
     --include "Block audio ads" \
     --include "Settings" \
     --include "Auto claim channel points" \
     --include "Show deleted messages" \
     twitch.apk

mv twitch-patched.apk tv.twitch.android.app.apk
