#!/bin/bash

# Function for checking whether a command is installed
checkCommandInstalled() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is not installed. Please install the package and run the script again."
    exit 1
  fi
}

debugEcho() {
    if [ "$debug" = "true" ]; then
        echo "$@"
    fi
}

debugEcho "Load settings from settings.env"
source "$(dirname "$0")/settings.env"

# Check if jq + openssl is installed
checkCommandInstalled "jq"
checkCommandInstalled "openssl"

# TLSA 3 1 1 Create entry
debugEcho "Create TLSA 3 1 1 entry"
newCertHash_311=$(openssl x509 -in $tlsaScriptMailcowCert -noout -pubkey | openssl pkey -pubin -outform DER | openssl dgst -sha256 -binary | hexdump -ve '/1 "%02x"')
debugEcho "New certificate hash (3 1 1): $newCertHash_311"

# TLSA 3 1 2 Create entry
debugEcho "Create TLSA 3 1 2 entry"
newCertHash_312=$(openssl x509 -in $tlsaScriptMailcowCert -noout -pubkey | openssl pkey -pubin -outform DER | openssl dgst -sha512 -binary | hexdump -ve '/1 "%02x"')
debugEcho "New certificate hash (3 1 2): $newCertHash_312"

# Create JSON content
debugEcho "Create JSON content"
jsonContent=$(cat <<EOF
{
    "mailserver": {
        "domain": "$tlsaScriptMailcowDomain",
        "cert_311": "$newCertHash_311",
        "cert_312": "$newCertHash_312"
    }
}
EOF
)
debugEcho "JSON-Inhalt: $jsonContent"

# Check whether the certHash has changed
currentJsonFile="$tlsaScriptDir/tlsa_record.json"

if [ -f "$currentJsonFile" ]; then
    currentCertHash_311=$(jq -r '.mailserver.cert_311' "$currentJsonFile")
    currentCertHash_312=$(jq -r '.mailserver.cert_312' "$currentJsonFile")
    debugEcho "Current certificate hash (3 1 1) from $currentJsonFile: $currentCertHash_311"
    debugEcho "Current certificate hash (3 1 2) from $currentJsonFile: $currentCertHash_312"
else
    currentCertHash_311=""
    currentCertHash_312=""
    debugEcho "File $currentJsonFile does not exist. Set current certificate hash to empty"
fi

if [ "$newCertHash_311" != "$currentCertHash_311" ] || [ "$newCertHash_312" != "$currentCertHash_312" ]; then
    debugEcho "The new certificate hash is different from the current hash. Update $currentJsonFile"
    echo "$jsonContent" > "$currentJsonFile"
    debugEcho "Execute Docker command: /usr/bin/docker run --rm -i -v \"$tlsaScriptDir:/dns\" ghcr.io/stackexchange/dnscontrol push --notify"
    docker run --rm -i -v "$tlsaScriptDir:/dns" ghcr.io/stackexchange/dnscontrol push --notify
else
    debugEcho "The new certificate hash is identical to the current hash. No action required."
fi