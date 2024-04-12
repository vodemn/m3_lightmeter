defaults -currentHost write -g AppleFontSmoothing -int 0
goldens=$(find ./test -name "*_golden_test.dart" -print)
for f in $goldens; do
    flutter test "$f" --dart-define cameraStubImage=assets/camera_stub_image.jpg --update-goldens
done
defaults -currentHost write -g AppleFontSmoothing -int 3
