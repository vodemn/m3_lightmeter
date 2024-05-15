simulators_array=("iPhone 13 Pro" "iPad Pro (12.9-inch) (6th generation)")
open -a Simulator
for i in "${simulators_array[@]}"; do # https://www.baeldung.com/linux/shell-script-iterate-over-string-list#2-understanding--and--special-indices
    echo "$i"
    xcrun simctl boot "$i"
    sh screenshots/scripts/generate_screenshots.sh "$i"
done
killall 'Simulator'

# dart run screenshots/main.dart -p ios -d iphone_13_pro -l iphone55inch
# dart run screenshots/main.dart -p ios -d iphone_13_pro -l iphone65inch
# dart run screenshots/main.dart -p ios -d ipad_pro_12.9-inch_6th_generation -l ipad13inch
