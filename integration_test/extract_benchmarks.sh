timeline_name="$1"

if [[ -n "$timeline_name" ]]; then
    echo "====== Extracting & merging ${timeline_name} timelines ======"

    timelines=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline.json" -print)
    dart run /Users/vodemn/Documents/GitHub/timeline_compare/bin/merge_timelines.dart $timelines

    summaries=$(find ./build -maxdepth 1 -name "${timeline_name}*.timeline_summary.json" -print)
    dart run /Users/vodemn/Documents/GitHub/timeline_compare/bin/merge_timeline_summaries.dart $summaries
else
    echo "Provide the timeline name"
fi
