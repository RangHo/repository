#!/bin/sh

# Version constants
REVANCED_CLI_VERSION="4.6.0"
REVANCED_PATCHES_VERSION="4.6.0"
REVANCED_INTEGRATIONS_VERSION="1.7.0"

TWITCH_DOWNLOAD_URL="https://dw.uptodown.net/dwn/Oy2NVcMk0KWcIugrRZyAGz4YMiAeg2XtDmw4b_vA4OhbBUlQhG53TfhhpLFkRiIZF7VVaEzRqLblf0Kafetu7NmkF0yTbZIWHSIDisERZCJF7UYGszdnzu-Kg4iLdyao/PcYHuOaLz7uMXEF6Tnc37OUUe444IhOG5F5de_F9Q4cROL_WlRYM9G83VfXn1B-KyV9yVCxXfsEX7B27M2yVKyeLGXDUOdylXa2qCbG2hDlBa7h2qdfgyiIgVvzmrvxY/MwpL0KlNTWj8F_LlB_YKOO9piTd6q3Wm2j95hJ3bJL0inY6_60_chGkGkMMs1wJzldMMniSYQN0b4rNhZPLpRA==/twitch-16-9-1.apk"

echo "Downloading ReVanced utilities..."
curl -Lo revanced-cli.jar \
     "https://github.com/ReVanced/revanced-cli/releases/download/v${REVANCED_CLI_VERSION}/revanced-cli-${REVANCED_CLI_VERSION}-all.jar"
curl -Lo revanced-patches.jar \
     "https://github.com/ReVanced/revanced-patches/releases/download/v${REVANCED_PATCHES_VERSION}/revanced-patches-${REVANCED_PATCHES_VERSION}.jar"
curl -Lo revanced-integrations.jar \
     "https://github.com/ReVanced/revanced-integrations/releases/download/v${REVANCED_INTEGRATIONS_VERSION}/revanced-integrations-${REVANCED_INTEGRATIONS_VERSION}.apk"

echo "Downloading official Twitch APK..."
curl -Lo twitch.apk \
     -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0" \
     "${TWITCH_DOWNLOAD_URL}"

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
