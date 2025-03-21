simulators_array=("iPhone 13 Pro" "iPad Pro (12.9-inch) (6th generation)")
open -a Simulator
for i in "${simulators_array[@]}"; do # https://www.baeldung.com/linux/shell-script-iterate-over-string-list#2-understanding--and--special-indices
    echo "$i"
    xcrun simctl boot "$i"
    sh screenshots/scripts/generate_screenshots.sh "$i"
done
killall 'Simulator'

dart run screenshots/convert_to_store_screenshots.dart -p ios -d iphone_13_pro -l iphone55inch
dart run screenshots/convert_to_store_screenshots.dart -p ios -d iphone_13_pro -l iphone65inch