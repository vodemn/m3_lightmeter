flutter test --coverage
lcov --remove coverage/lcov.info 'lib/generated/*' 'lib/l10n/*' -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html
open coverage/html/index.html