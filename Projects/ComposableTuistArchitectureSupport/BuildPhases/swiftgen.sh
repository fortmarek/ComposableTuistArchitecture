#!/bin/sh

pushd "../.."

SHARED_IMG_SRC_FILE="${SRCROOT}/Resources/Images.xcassets"
ASSETS_DST_FILE="${SRCROOT}/Sources/Model/Generated/Assets.swift"

echo "[SwiftGen] Generating assets"
mint run swiftgen run xcassets -t swift4 "$SHARED_IMG_SRC_FILE" -o "${ASSETS_DST_FILE}" --param publicAccess=true
popd