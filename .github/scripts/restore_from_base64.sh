content="$1"
filename="$2"

if [[ ! -n "$content" ]]; then
    echo "Provide file content"
    exit 1
fi

if [[ ! -n "$filename" ]]; then
    echo "Provide a path to an output file"
    exit 1
fi

echo -n "$content" | base64 --decode --output "$filename"
