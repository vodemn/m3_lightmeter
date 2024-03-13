# M3 Lightmeter integration tests

### List of executed tests:

- [Purchases test](integration_test/purchases_test.dart)
- [Metering screen layout test](integration_test/metering_screen_layout_test.dart)
- [e2e](integration_test/e2e_test.dart)

### Run all tests

```console
flutter drive \
    --target=integration_test/run_all_tests.dart \
    --driver=test_driver/integration_driver.dart \
    --flavor=dev \
    --no-dds \
    --dart-define cameraStubImage=assets/camera_stub_image.jpg
```
