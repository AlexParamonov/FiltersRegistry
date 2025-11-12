# AdGuard Base Filter - eBlocker Compatible Version

This is a converted version of the AdGuard Base filter specifically for use with eBlocker.

## What was changed?

eBlocker uses EasyList syntax parser which doesn't support all AdGuard-specific modifiers. The following rules were removed:

### Stripped Modifiers (rules kept, modifier removed):
- `$important` - Priority modifier (51 rules) - Kept as normal priority rules
- `$all` - Blocks all request types (226 rules) - Kept as standard blocking rules

### Removed Modifiers (entire rules removed):
**AdGuard-specific (not in EasyList spec):**
- `$network` - IP address blocking (59 rules)
- `$redirect-rule=` - AdGuard redirect rules (1 rule)
- `$redirect=` - Resource redirection (118 rules)
- `$denyallow=` - Complex whitelist syntax (0 rules)
- `$replace=` - Content replacement (386 rules)
- `$to=` / `$from=` - URL rewriting (0 rules)
- `$badfilter` - Filter negation (24 rules)

### Removed Syntax:
- `*$...` - Wildcard rules that match everything
- `#%#` / `#@%#` - JavaScript injection rules
- `#$#` / `#@$#` - Advanced CSS injection
- `#?#` - Extended CSS selectors

## Statistics

- **Original filter**: 154,379 lines (134,157 non-comment rules)
- **eBlocker compatible**: 98,618 lines (79,718 non-comment rules)
- **Removed**: 55,761 lines (54,439 non-comment rules / 40.6%)

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
