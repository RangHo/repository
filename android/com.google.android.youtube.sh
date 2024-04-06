#!/bin/sh

# Version constants
REVANCED_CLI_VERSION="4.6.0"
REVANCED_PATCHES_VERSION="4.6.0"
REVANCED_INTEGRATIONS_VERSION="1.7.0"

YOUTUBE_DOWNLOAD_URL="https://dw.uptodown.net/dwn/GQhdVlAFQSoZNp-O95q_cmxUFxMBVqLM5sng2WFVDSNCz_s4MWVkk85rMnBOEXXQT2HaX5JTzqI1-3gvd7zryDDy4swXrwpsO07vOe0cN3alayBC2DIc6SEgSHvlMqxK/wQfOk-5wANcklUlQUEQW_NJW88zfodSKxnq9m95AR2qyWcY1_ZszXUkBkDkixWpH6rUTS4O0wuIztRhtDoQYTtz68O6aImnbvibbnqJtUKBA32ZJ-0HgbWOtO6hpX7_A/M-A1sKnq70dfVUcurm3x98mGD3pbgoNZUoMiAlMEsq-UaNRbgHVIBMLoVyv8W2vsi0YwoTUbA7x-IF5-7vlmvQ==/youtube-19-12-41.apk"

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
{
  "patchName" : "GmsCore support",
  "options" : [ {
    "key" : "gmsCoreVendorGroupId",
    "value" : "app.revanced"
  } ]
}
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
