export newVersion="$1"

if [[ -n "$newVersion" ]]; then
    #https://stackoverflow.com/a/30214769/13167574
    perl -i -pe 's/^(version:\s+)(\d+\.\d+\.\d+)(\+)(\d+)$/$1.$ENV{'newVersion'}.$3.($4+1)/e' pubspec.yaml
else
    echo "argument error"
fi
