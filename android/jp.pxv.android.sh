#!/bin/sh

# Version constants
REVANCED_CLI_VERSION="4.6.0"
REVANCED_PATCHES_VERSION="4.6.0"
REVANCED_INTEGRATIONS_VERSION="1.7.0"

PIXIV_DOWNLOAD_URL="https://dw.uptodown.net/dwn/Oy2NVcMk0KWcIugrRZyAGz4YMiAeg2XtDmw4b_vA4OjZETnpjOLknIqSu4wfqR5tgMXQ4iDUULo_pMcXvMRrbxrPhIQJZhrzAS8xWBzwp7muoZ6xo_sRYwHndqPDCpWD/uJvEbrOVIYjBNzGPx8orZV6VdFBrj-ilGUYtk3wxfykIOb0aUW8m_s7LExTaSxD0b9dyC7cYEUNuMjQ-ww60H3my2tgE5u-4QDqNQHspY7BbpA72YwgD5u7ouFSzyy8e/zkAWuQgKMYn5i1-rtEBHF0l8M0NbGftu4kn7KQk81JVz_ol8g_AHxd8U95vm0u09/pixiv-6-103-0.apk"

echo "Downloading ReVanced utilities..."
curl -Lo revanced-cli.jar \
     "https://github.com/ReVanced/revanced-cli/releases/download/v${REVANCED_CLI_VERSION}/revanced-cli-${REVANCED_CLI_VERSION}-all.jar"
curl -Lo revanced-patches.jar \
     "https://github.com/ReVanced/revanced-patches/releases/download/v${REVANCED_PATCHES_VERSION}/revanced-patches-${REVANCED_PATCHES_VERSION}.jar"
curl -Lo revanced-integrations.jar \
     "https://github.com/ReVanced/revanced-integrations/releases/download/v${REVANCED_INTEGRATIONS_VERSION}/revanced-integrations-${REVANCED_INTEGRATIONS_VERSION}.apk"

echo "Downloading official Pixiv APK..."
curl -Lo pixiv.apk \
     -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0" \
     "${PIXIV_DOWNLOAD_URL}"

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
