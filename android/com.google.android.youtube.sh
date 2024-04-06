#!/bin/sh

# Version constants
REVANCED_CLI_VERSION="4.6.0"
REVANCED_PATCHES_VERSION="4.6.0"
REVANCED_INTEGRATIONS_VERSION="1.7.0"

YOUTUBE_DOWNLOAD_URL="https://dw.uptodown.net/dwn/GQhdVlAFQSoZNp-O95q_cmxUFxMBVqLM5sng2WFVDSNuZ7DGkOG-PbbYK6TWeVHwfEbPRO4zW3y1AfarEkp2K6JJ0wfkKFF13wmKYX40-YGLzRS5DZIhFkNlsy3bHQ4D/i1XNwSCw5jfzk59XR4J5BMt3SWl4PHGV5rVPp1eR_rhtoMQ5qLHgHy5dLafQYOYU-j7A0NuqhkBT3ykZX-A9DNJf1AL-_Mb_YmmYJ78z-Dc7nTJZN9VZXlGULbqCPJpi/ZhuzkvKPeJ5-9nkD2SH9YbAWYh0x5ArRKBnTfxBh8yTLXML5qcHjRIuI7B0U6zL2M5YpHYP6o3eTNTOBaapsug==/youtube-19-09-37.apk"

echo "Downloading ReVanced utilities..."
curl -Lo revanced-cli.jar \
     "https://github.com/ReVanced/revanced-cli/releases/download/v${REVANCED_CLI_VERSION}/revanced-cli-${REVANCED_CLI_VERSION}-all.jar"
curl -Lo revanced-patches.jar \
     "https://github.com/ReVanced/revanced-patches/releases/download/v${REVANCED_PATCHES_VERSION}/revanced-patches-${REVANCED_PATCHES_VERSION}.jar"
curl -Lo revanced-integrations.jar \
     "https://github.com/ReVanced/revanced-integrations/releases/download/v${REVANCED_INTEGRATIONS_VERSION}/revanced-integrations-${REVANCED_INTEGRATIONS_VERSION}.apk"

echo "Downloading official YouTube APK..."
curl -Lo youtube.apk \
     -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0" \
     "${YOUTUBE_DOWNLOAD_URL}"

echo "Patching YouTube APK..."
cat <<EOF >options.json
[
    {
        "patchName" : "GmsCore support",
        "options" : [{
            "key" : "gmsCoreVendorGroupId",
            "value" : "app.revanced"
        }]
    },
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
     --exclusive \
     --include "GmsCore support" \
     --include "Client spoof" \
     --include "Change package name" \
     --include "Hide ads" \
     --include "Video ads" \
     --include "Minimized playback" \
     --include "Hide Shorts components" \
     --include "Disable resuming Shorts on startup" \
     --include "Remove tracking query parameter" \
     --include "Remove viewer discretion dialog" \
     --include "Copy video URL" \
     --include "SponsorBlock" \
     --include "Return YouTube Dislike" \
     --include "Downloads" \
     --include "Enable debugging" \
     youtube.apk

mv youtube-patched.apk com.google.android.youtube.apk
