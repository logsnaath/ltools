#!/bin/bash

LICENSE_CONTENT=$(cat << 'EOF'
Put your license content here.
You can have multiple lines.
# Author: Logu<logu.rangasamy@suse.com>
EOF
)

LICENSELEN=$(echo "$LICENSE_CONTENT" | wc -l)

for f in "$@"; do
  head -"$LICENSELEN" "$f" | diff <(echo "$LICENSE_CONTENT") - || { { echo "$LICENSE_CONTENT"; echo; cat "$f"; } > /tmp/file; mv /tmp/file "$f"; }
done

