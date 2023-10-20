flutter test --coverage
flutter test integration_test --flavor=dev --coverage

file=test/coverage_helper_test.dart
echo "// Helper file to make coverage work for all dart files\n" > $file
echo "// ignore_for_file: unused_import, directives_ordering" >> $file
find lib '!' -path '*generated*/*' '!' -name '*.g.dart' '!' -name '*.part.dart' -name '*.dart' | cut -c4- | awk -v package=$1 '{printf "import '\''package:lightmeter%s%s'\'';\n", package, $1}' >> $file
echo "void main() {}" >> $file

lcov --remove coverage/lcov.info 'lib/generated/*' 'lib/l10n/*' -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html
open coverage/html/index.html