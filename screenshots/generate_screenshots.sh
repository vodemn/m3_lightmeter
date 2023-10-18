flutter drive \
    --dart-define="cameraPreviewAspectRatio=240/320" \
    --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
    --driver=test_driver/screenshot_driver.dart \
    --target=screenshots/generate_screenshots.dart \
    --profile \
    --flavor=dev \
    --no-dds \
    --endless-trace-buffer \
    --purge-persistent-cache
