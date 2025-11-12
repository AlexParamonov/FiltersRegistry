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

# Step 1: Remove completely unsupported rules (BEFORE stripping modifiers)
# Step 2: Strip modifiers that are safe to remove
grep -v '^\*\$' "$INPUT_FILE" | \
  grep -v '\$network' | \
  grep -v '\$redirect-rule=' | \
  grep -v ',redirect-rule=' | \
  grep -v '^\$.*redirect-rule=' | \
  grep -v '\$redirect=' | \
  grep -v ',redirect=' | \
  grep -v '^\$.*redirect=' | \
  grep -v '\$important,redirect=' | \
  grep -v '\$denyallow=' | \
  grep -v '\$replace=' | \
  grep -v ',replace=' | \
  grep -v '^\$.*replace=' | \
  grep -v '\$to=' | \
  grep -v '\$from=' | \
  grep -v '\$badfilter' | \
  grep -v '\$all,badfilter' | \
  grep -v '\$all,removeparam=' | \
  grep -v '\$all,urltransform=' | \
  grep -v '\$jsonprune' | \
  grep -v '\$cookie' | \
  grep -v '\$jsinject' | \
  grep -v ',jsinject' | \
  grep -v ',cookie' | \
  grep -v ',extension=' | \
  grep -v '\$app=' | \
  grep -v ',app=' | \
  grep -v '\$removeparam' | \
  grep -v '\$hls' | \
  grep -v '\$referrerpolicy' | \
  grep -v '\$urltransform' | \
  grep -v '\$removeheader' | \
  grep -v '\$xmlprune' | \
  grep -v '\$rpc' | \
  grep -v '\$extension=' | \
  grep -v '#%#' | \
  grep -v '#@%#' | \
  grep -v '#\$#' | \
  grep -v '#@\$#' | \
  grep -v '#\?#' | \
  grep -v '\$\$' | \
  sed 's/\$important,/$/g' | \
  sed 's/,\$important//g' | \
  sed 's/\$important\r\?$//g' | \
  sed 's/\$all,/$/g' | \
  sed 's/,\$all\r\?$//g' | \
  sed 's/\$all\r\?$//g' | \
  sed 's/\$stealth=[^,]*,/$/g' | \
  sed 's/,\$stealth=[^,]*//g' | \
  sed 's/\$stealth=[^,]*\r\?$//g' | \
  sed 's/\$stealth,/$/g' | \
  sed 's/,\$stealth//g' | \
  sed 's/\$stealth\r\?$//g' | \
  sed 's/\$extension,/$/g' | \
  sed 's/,\$extension//g' | \
  sed 's/\$extension\r\?$//g' | \
  sed 's/\$urlblock,/$/g' | \
  sed 's/,\$urlblock//g' | \
  sed 's/\$urlblock\r\?$//g' | \
  sed 's/\$content,/$/g' | \
  sed 's/,\$content//g' | \
  sed 's/\$content\r\?$//g' | \
  sed 's/\$match-case,/$/g' | \
  sed 's/,\$match-case//g' | \
  sed 's/\$match-case\r\?$//g' | \
  grep -v -E '^\$[a-z]' | \
  grep -v '^[[:space:]]*$' > "$OUTPUT_FILE"

echo ""
echo "Conversion complete!"
echo "Original lines: $(wc -l < "$INPUT_FILE")"
echo "Converted lines: $(wc -l < "$OUTPUT_FILE")"
echo "Removed lines: $(($(wc -l < "$INPUT_FILE") - $(wc -l < "$OUTPUT_FILE")))"
echo ""
echo "Modifiers stripped (rules kept):"
echo "  - \$important, \$all (priority modifiers)"
echo "  - \$stealth (privacy features - mostly whitelists)"
echo "  - \$extension, \$urlblock, \$content (browser-specific)"
echo "  - \$match-case (case sensitivity)"
echo ""
echo "Rules deleted entirely:"
echo "  - Wildcard rules: *\$..."
echo "  - Content modification: \$jsonprune, \$xmlprune, \$removeparam, \$urltransform"
echo "  - Header modification: \$removeheader, \$referrerpolicy, \$cookie"
echo "  - Advanced features: \$jsinject, \$app, \$hls, \$rpc"
echo "  - Filter control: \$network, \$redirect=, \$replace=, \$badfilter"
echo "  - Advanced syntax: #%#, #\$#, #?#"
