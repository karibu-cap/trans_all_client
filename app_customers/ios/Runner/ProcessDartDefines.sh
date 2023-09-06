#!/bin/bash

# Generate DartEnvironmentVariables.xcconfig from dart defines.

# Use dev as the default environment.
TRANSTU_APP_ENVIRONMENT="dev"
TRANSTU_APP_NAME="TransTu.DEV"
FIREBASE_REVERSED_CLIENT_ID="${FIREBASE_REVERSED_CLIENT_ID:-com.googleusercontent.apps.812086350186-09pa4a8quf283qu955f4dioajh5frokc}"

# Override any existing file.
printf "TRANSTU_APP_ENVIRONMENT=%s\n" "${TRANSTU_APP_ENVIRONMENT}" > ${SRCROOT}/Flutter/DartEnvironmentVariables.xcconfig
printf "TRANSTU_APP_NAME=%s\n" "${TRANSTU_APP_NAME}" >> ${SRCROOT}/Flutter/DartEnvironmentVariables.xcconfig
printf "FIREBASE_REVERSED_CLIENT_ID=%s\n" "${FIREBASE_REVERSED_CLIENT_ID}" >> ${SRCROOT}/Flutter/DartEnvironmentVariables.xcconfig

# Starting Flutter 2.2, dart-define values are base64 encoded.
function entry_decode() { echo "${*}" | base64 --decode; }

IFS=',' read -r -a define_items <<< "$DART_DEFINES"

for index in "${!define_items[@]}"
do
    define_items[$index]=$(entry_decode "${define_items[$index]}");

    # Get the property name and the property value.
    field="${define_items[$index]%=*}"
    value="${define_items[$index]#*=}"

    if [ "$field" == "TRANSTU_APP_ENVIRONMENT" ]; then
        TRANSTU_APP_ENVIRONMENT=${value}
    fi
done

# Write the environment variables to the xcconfig file.
printf "%s\n" "${define_items[@]}" >> ${SRCROOT}/Flutter/DartEnvironmentVariables.xcconfig

# Copy the appropriate GoogleService-Info plist to the Runner directory.
cp ${SRCROOT}/Runner/Services/${TRANSTU_APP_ENVIRONMENT}/GoogleService-Info.plist ${SRCROOT}/Runner/GoogleService-Info.plist
