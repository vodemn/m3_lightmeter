cp "scripts/mocks/mock_constants.dart" "lib/constants.dart"
cp "scripts/mocks/mock_firebase_options.dart" "lib/firebase_options.dart"
cp "scripts/mocks/mock_firebase.json" "firebase.json"

curl -H 'Accept: application/vnd.github.v3.raw' \
    -o "android/app/google-services.json" \
    -L "https://api.github.com/repos/firebase/quickstart-android/contents/mock-google-services.json"
curl -H 'Accept: application/vnd.github.v3.raw' \
    -o "ios/Runner/GoogleService-Info.plist" \
    -L "https://api.github.com/repos/firebase/quickstart-ios/contents/mock-GoogleService-Info.plist"

sh .github/scripts/stub_iap.sh
