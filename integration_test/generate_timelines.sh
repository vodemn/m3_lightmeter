flutter --version
fvm flutter build apk \
    --dart-define="cameraPreviewAspectRatio=240/320" \
    --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
    --target=integration_test/generate_screenshots.dart \
    --profile \
    --flavor=dev

for n in {1..5}; do
    echo "============ Run number ${n} ============"

    flutter drive \
        --dart-define="cameraPreviewAspectRatio=240/320" \
        --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
        --driver=test_driver/screenshot_driver.dart \
        --target=integration_test/generate_screenshots.dart \
        --profile \
        --flavor=dev \
        --no-dds \
        --endless-trace-buffer \
        --purge-persistent-cache \
        --use-application-binary=build/app/outputs/flutter-apk/app-dev-profile.apk
done

