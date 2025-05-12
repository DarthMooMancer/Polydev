#!/usr/bin/env bash
# Start from the current directory
DIR="$(pwd)"

# Walk up until we find a marker or reach root
while [[ ! -f "$DIR/CMakeLists.txt" && \
         ! -f "$DIR/package.json" && \
         ! -f "$DIR/venv" && \
         ! -d "$DIR/.git" && \
         "$DIR" != "/" ]]; do
  DIR="$(dirname "$DIR")"
done

# Check if root was reached without finding anything
if [[ "$DIR" == "/" ]]; then
  echo "❌ Project root not found."
  exit 1
fi

echo "$DIR"

