#/bin/sh

VANCED_MICROG_VERSION="0.2.24.220220-220220001"

echo "Downloading Vanced MicroG v$VANCED_MICROG_VERSION..."
curl -L -o com.mgoogle.android.gms.apk "https://github.com/TeamVanced/VancedMicroG/releases/download/v${VANCED_MICROG_VERSION}/microg.apk"
