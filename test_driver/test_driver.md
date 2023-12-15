https://github.com/gskinnerTeam/flutter-folio/tree/master/benchmark
https://github.com/2d-inc/developer_quest/blob/master/test_driver/performance_test.dart



Trace actions
```console
flutter drive \
  --driver=test_driver/performance_driver.dart \
  --target=integration_test/widget_dialog_animated_test.dart \
  --profile \
  --flavor=dev \
  --no-dds
```