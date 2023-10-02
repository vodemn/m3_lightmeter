flutter drive \
    --dart-define="cameraPreviewAspectRatio=240/320" \
    --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
    --driver=test_driver/performance_driver.dart \
    --target=integration_test/metering_test.dart \
    --profile \
    --flavor=dev \
    --no-dds \
    --endless-trace-buffer \
    --purge-persistent-cache
