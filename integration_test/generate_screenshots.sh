flutter drive \
    --dart-define="cameraPreviewAspectRatio=240/320" \
    --driver=test_driver/screenshot_driver.dart \
    --target=integration_test/generate_screenshots.dart \
    --profile \
    --flavor=dev \
    --no-dds \
    --endless-trace-buffer \
    --purge-persistent-cache
