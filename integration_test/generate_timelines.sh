flutter --version
fvm flutter build apk \
    --dart-define="cameraPreviewAspectRatio=240/320" \
    --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
    --target=integration_test/metering_test.dart \
    --profile \
    --flavor=dev

for n in {1..25}; do
    echo "============ Run number ${n} ============"

    flutter drive \
        --dart-define="cameraPreviewAspectRatio=240/320" \
        --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
        --driver=test_driver/performance_driver.dart \
        --target=integration_test/metering_test.dart \
        --profile \
        --flavor=dev \
        --no-dds \
        --endless-trace-buffer \
        --purge-persistent-cache \
        --use-application-binary=build/app/outputs/flutter-apk/app-dev-profile.apk
done

sh integration_test/extract_benchmarks.sh toggle_iso_picker