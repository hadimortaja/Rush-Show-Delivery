#!/bin/bash 
PATH_PROJECT=$(pwd)
APP_NAME=${PWD##*/}

# build apk
flutter clean
flutter pub get
flutter build apk --release
flutter build appbundle --target-platform android-arm,android-arm64,android-x64

# keytool -genkey -v -keystore android/app/cert/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
# keytool -list -v -keystore android/app/cert/key.jks -alias key

# move file app-release.aab to folder certs
cp "$PATH_PROJECT/build/app/outputs/flutter-apk/app-release.apk" "$PATH_PROJECT/$APP_NAME.apk"
cp "$PATH_PROJECT/build/app/outputs/bundle/release/app-release.aab" "$PATH_PROJECT/$APP_NAME.aab"
