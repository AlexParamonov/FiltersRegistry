# AdGuard Base Filter - eBlocker Compatible Version

This is a converted version of the AdGuard Base filter specifically for use with eBlocker.

## What was changed?

eBlocker uses EasyList syntax parser which doesn't support all AdGuard-specific modifiers. The following rules were removed:

### Stripped Modifiers (rules kept, modifier removed):
**Priority & Matching:**
- `$important` - Priority modifier - Kept as normal priority rules
- `$all` - Blocks all request types - Kept as standard blocking rules
- `$match-case` - Case-sensitive matching - eBlocker default is case-sensitive

**Privacy Features (mostly whitelists):**
- `$stealth` - AdGuard Stealth Mode features - ~1,470 rules (99% whitelists)
- `$extension` - Browser extension specific - Whitelists work without it
- `$urlblock` - URL blocking whitelist - Generic whitelist works
- `$content` - Content type whitelist - Generic whitelist works

### Removed Modifiers (entire rules removed):
**Content/Response Modification:**
- `$jsonprune=` - JSON response manipulation (25 rules)
- `$xmlprune=` - XML/DASH manifest pruning (2 rules)
- `$removeparam` - URL parameter removal (11 rules)
- `$urltransform=` - URL rewriting (3 rules)
- `$replace=` - Content replacement (386 rules)

**Header Modification:**
- `$removeheader=` - HTTP header removal (3 rules)
- `$referrerpolicy=` - Referrer-Policy header (4 rules)
- `$cookie=` - Cookie filtering (21 rules)

**Advanced Features:**
- `$jsinject` - JavaScript injection (19 rules)
- `$app=` - Application-specific rules (12 rules)
- `$hls=` - HLS stream filtering (5 rules)
- `$rpc/` - gRPC filtering (2 rules)

**Filter Control:**
- `$network` - IP address blocking (59 rules)
- `$redirect=` - Resource redirection (118 rules)
- `$redirect-rule=` - AdGuard redirect rules (1 rule)
- `$denyallow=` - Complex whitelist syntax (0 rules)
- `$badfilter` - Filter negation (24 rules)
- `$to=` / `$from=` - URL rewriting (0 rules)

### Removed Syntax:
- `*$...` - Wildcard rules that match everything (13 rules)
- `#%#` / `#@%#` - JavaScript injection rules (~4,700 rules)
- `#$#` / `#@$#` - Advanced CSS injection rules (~4,350 rules)
- `#?#` - Extended CSS selectors (included in above)
- `$$` - HTML filtering rules (238 rules)

## Statistics

- **Original filter**: 154,379 lines (134,157 non-comment rules)
- **eBlocker compatible**: 98,207 lines (79,333 non-comment rules)
- **Removed**: 56,172 lines (54,824 non-comment rules / 40.9%)

## What's Kept (Supported by eBlocker)?

**Standard EasyList syntax:**
- Domain blocking: `||domain.com^`
- URL pattern blocking: `/pattern/`
- Element hiding: `##.selector`
- Exception rules: `@@||domain.com^`

**Fully supported modifiers:**
- `$third-party`, `$script`, `$image`, `$stylesheet`, `$object`
- `$xmlhttprequest`, `$object-subrequest`, `$subdocument`
- `$document`, `$elemhide`, `$generichide`, `$genericblock`
- `$other`, `$collapse`, `$media`, `$font`
- `$domain=`, `$csp=`

**Recognized but dropped (rules with these are kept but modifier ignored):**
- `$ping`, `$popup`, `$webrtc`, `$websocket`

## Usage with eBlocker

1. Upload `filter.txt` to eBlocker via Settings → Blocker → Overview
2. Add as a custom Pattern Blocker list
3. The filter will provide ad and tracker blocking without false positives

## Conversion Script

See `../../convert_for_eblocker.sh` for the conversion script that generates this filter.

## Updates

To update this filter:
1. Update the original AdGuard Base filter in `../filter_2_Base/`
2. Run: `./convert_for_eblocker.sh`
3. Copy the result to this directory

## License

Same as original AdGuard Base filter: https://github.com/AdguardTeam/AdguardFilters/blob/master/LICENSE
