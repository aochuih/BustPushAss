#!/bin/sh

echo "*********************************"
echo "Sending push notification"
echo "*********************************"

echo "payload: ${2}\n"
"${1}" -d "${2}" --cert "${3}" -H "apns-topic:${4}" --http2 https://"${5}"/3/device/"${6}"

echo "*********************************"
echo "Done 🍺"
echo "*********************************"
