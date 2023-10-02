timeline_name="$1"

if [[ -n "$timeline_name" ]]; then
    echo "====== Extracting & merging ${timeline_name} timelines ======"

    extent_micros="timeExtentMicros"
    timelines=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline.json" -print)
    for i in "${timelines[@]}"; do
        extent_micros+="$(grep -A0 -h '"timeExtentMicros":' $i | grep -o " [0-9]*")"
    done
    echo $extent_micros | tr ' ' ',' >>${csv_filename}.csv

    benchmarks=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline.benchmark" -print)
    benchmerge $benchmarks
else
    echo "Provide the timeline name"
fi
