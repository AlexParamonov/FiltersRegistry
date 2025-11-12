#!/bin/bash
# Script to convert AdGuard Base filter to eBlocker-compatible format

INPUT_FILE="filters/filter_2_Base/filter.txt"
OUTPUT_FILE="filters/filter_2_Base/filter_eblocker.txt"

echo "Converting AdGuard Base filter for eBlocker compatibility..."
echo "Input: $INPUT_FILE"
echo "Output: $OUTPUT_FILE"

# eBlocker SUPPORTS these modifiers (from BooleanOption enum + special handling):
# - third-party, script, image, stylesheet, object, xmlhttprequest, object-subrequest, subdocument
# - document, elemhide, generichide, genericblock, other, collapse, media, font
# - domain=, csp=
#
# eBlocker RECOGNIZES but DROPS (line 47-52):
# - ping, websocket, popup, webrtc
#
# eBlocker IGNORES (silently):
# - all, network, redirect-rule=, redirect=, denyallow=, replace=, important, badfilter, to=, from=, etc.

# Step 1: First remove completely unsupported rules (BEFORE stripping $important/$all)
# Step 2: Then strip $important and $all modifiers from remaining valid rules
grep -v '^\*\$' "$INPUT_FILE" | \
  grep -v '\$network' | \
  grep -v '\$redirect-rule=' | \
  grep -v '\$redirect=' | \
  grep -v '\$important,redirect=' | \
  grep -v '\$denyallow=' | \
  grep -v '\$replace=' | \
  grep -v '\$to=' | \
  grep -v '\$from=' | \
  grep -v '\$badfilter' | \
  grep -v '\$all,badfilter' | \
  grep -v '\$all,match-case' | \
  grep -v '\$all,removeparam=' | \
  grep -v '\$all,urltransform=' | \
  grep -v '#%#' | \
  grep -v '#@%#' | \
  grep -v '#\$#' | \
  grep -v '#@\$#' | \
  grep -v '#\?#' | \
  sed 's/\$important,/$/g' | \
  sed 's/,\$important//g' | \
  sed 's/\$important\r\?$//g' | \
  sed 's/\$all,/$/g' | \
  sed 's/,\$all\r\?$//g' | \
  sed 's/\$all\r\?$//g' > "$OUTPUT_FILE"

echo ""
echo "Conversion complete!"
echo "Original lines: $(wc -l < "$INPUT_FILE")"
echo "Converted lines: $(wc -l < "$OUTPUT_FILE")"
echo "Removed lines: $(($(wc -l < "$INPUT_FILE") - $(wc -l < "$OUTPUT_FILE")))"
echo ""
echo "Kept (modifiers stripped):"
echo "  - \$important (STRIPPED - rules kept without modifier)"
echo "  - \$all (STRIPPED - rules kept without modifier)"
echo "  - \$ping, \$popup, \$webrtc, \$websocket (recognized but dropped by eBlocker)"
echo "  - \$generichide, \$genericblock (fully supported)"
echo "  - \$elemhide, \$document, \$collapse (fully supported)"
echo ""
echo "Removed (unsupported):"
echo "  - Wildcard rules: *\$..."
echo "  - AdGuard-specific: \$network, \$redirect-rule=, \$denyallow="
echo "  - \$badfilter (filter negation)"
echo "  - Advanced syntax: #%#, #\$#, #?#"
