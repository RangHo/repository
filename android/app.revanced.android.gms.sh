#/bin/sh

REVANCED_GMSCORE_URL="https://github.com/ReVanced/GmsCore/releases/download/v0.3.1.4.240913/app.revanced.android.gms-240913008-signed.apk"

echo "Downloading ReVanced GmsCore..."
curl -Lo app.revanced.android.gms.apk $REVANCED_GMSCORE_URL
