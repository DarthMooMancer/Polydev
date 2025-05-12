#!/usr/bin/env bash
DIR="$(pwd)"

while [[ ! -f "$DIR/CMakeLists.txt" && \
         ! -f "$DIR/package.json" && \
         ! -f "$DIR/venv" && \
         ! -d "$DIR/.git" && \
         "$DIR" != "/" ]]; do
  DIR="$(dirname "$DIR")"
done

if [[ "$DIR" == "/" ]]; then
  echo "❌ Project root not found."
  exit 1
fi

echo "$DIR"

