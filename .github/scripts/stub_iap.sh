# https://unix.stackexchange.com/questions/435708/regex-multiline-pattern-and-substitution-replacement
perl -0777 -i -pe 's/(  m3_lightmeter_iap:\n)(    git:\n      url: "https:\/\/github.com\/vodemn\/m3_lightmeter_iap"\n      ref: main)/$1    path: iap/sg' pubspec.yaml