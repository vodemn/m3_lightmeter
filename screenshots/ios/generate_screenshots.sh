devices_array=("iPhone 8 Plus" "iPhone 13 Pro" "iPhone 13 Pro Max" "iPhone 15 Pro" "iPhone 15 Pro Max" "iPad Pro (12.9-inch) (6th generation)")

open -a Simulator

for i in "${devices_array[@]}"; do # https://www.baeldung.com/linux/shell-script-iterate-over-string-list#2-understanding--and--special-indices
    echo "$i"
    xcrun simctl boot "$i"
    #uid=$(echo "$(fvm flutter devices)" | sed -n -r "s/$i \(mobile\) • (.*) • .* • .*\(simulator\)/\1/p")
    #echo $uid
    sh screenshots/generate_screenshots.sh "$i"
done

killall 'Simulator'
