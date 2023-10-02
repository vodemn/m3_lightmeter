timeline_name="$1"
csv_filename="$2"

if [[ -n "$timeline_name" ]]; then
    if [[ -z "$csv_filename" ]]; then
        csv_filename="${timeline_name}"
    fi

    echo "====== Extracting & merging ${timeline_name} timelines ======"
    echo "" >>${csv_filename}.csv
    echo "${timeline_name}" >>${csv_filename}.csv

    extent_micros="timeExtentMicros"
    timelines=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline.json" -print)
    for i in "${timelines[@]}"; do
        benchextract $i
        extent_micros+="$(grep -A0 -h '"timeExtentMicros":' $i | grep -o " [0-9]*")"
    done
    echo $extent_micros | tr ' ' ',' >>${csv_filename}.csv

    metrics=(
        "average_frame_build_time_millis"
        "90th_percentile_frame_build_time_millis"
        "99th_percentile_frame_build_time_millis"
        "worst_frame_build_time_millis"
        "average_rasterizer_time_millis"
        "90th_percentile_rasterizer_time_millis"
        "99th_percentile_rasterizer_time_millis"
        "worst_frame_rasterizer_time_millis"
    )

    timeline_summaries=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline_summary.json" -print)
    for i in "${timeline_summaries[@]}"; do
        metrics[0]+="$(grep -A0 -h '"average_frame_build_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[1]+="$(grep -A0 -h '"90th_percentile_frame_build_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[2]+="$(grep -A0 -h '"99th_percentile_frame_build_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[3]+="$(grep -A0 -h '"worst_frame_build_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[4]+="$(grep -A0 -h '"average_frame_rasterizer_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[5]+="$(grep -A0 -h '"90th_percentile_frame_rasterizer_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[6]+="$(grep -A0 -h '"99th_percentile_frame_rasterizer_time_millis":' $i | grep -o " [0-9.]*")"
        metrics[7]+="$(grep -A0 -h '"worst_frame_rasterizer_time_millis":' $i | grep -o " [0-9.]*")"
    done
    for metric in "${metrics[@]}"; do
        echo $metric | tr ' ' ',' >>${csv_filename}.csv
    done

    benchmarks=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline.benchmark" -print)
    benchmerge $benchmarks
else
    echo "Provide the timeline name"
fi
