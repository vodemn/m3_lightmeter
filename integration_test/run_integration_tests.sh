# https://github.com/flutter/flutter/issues/86295#issuecomment-1192766368
devices=$(adb devices)
devicesIds=$(echo $devices | grep -Eo '[A-Z0-9]{2,}')
firstDeviceId=$(echo $devicesIds | cut -d " " -f 1)
# adb -s $firstDeviceId shell pm grant com.vodemn.lightmeter.dev android.permission.CAMERA

flutter drive \
    --dart-define="cameraPreviewAspectRatio=240/320" \
    --dart-define="cameraStubImage=assets/camera_stub_image.jpg" \
    --driver=test_driver/integration_driver.dart \
    --target=integration_test/metering_screen_test.dart \
    --profile \
    --flavor=dev \
    --no-dds \
    --endless-trace-buffer \
    --purge-persistent-cache \
    -d $firstDeviceId