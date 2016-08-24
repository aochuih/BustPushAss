#!/bin/sh

echo "*********************************"
echo "Sending push notification"
echo "*********************************"

echo "payload: ${2}\n"
"${1}" -d "${2}" --cert "${3}" -H "apns-topic:${4}" --http2 https://api.push.apple.com/3/device/"${5}"

echo "*********************************"
echo "Done 🍺"
echo "*********************************"
