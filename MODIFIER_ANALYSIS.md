# AdGuard Modifier Analysis for eBlocker Conversion

Based on samples from the filter, here's what each modifier does:

## STRIP MODIFIER ONLY (keep rules, remove modifier):

### $stealth (1,469 rules - 99.7% whitelists)
- **Purpose**: Disables AdGuard's Stealth Mode features (referrer hiding, IP hiding, cookie blocking)
- **Type**: Almost all are exception rules (@@)
- **Decision**: **STRIP** - Whitelisting domains from stealth mode won't affect eBlocker
- **Example**: `@@||beinconnect.com.tr^$stealth` → `@@||beinconnect.com.tr^`

### $extension (18 rules - all whitelists)
- **Purpose**: Browser extension-specific rules
- **Decision**: **STRIP** - Not applicable to eBlocker but won't hurt
- **Example**: `@@||pilet.elron.ee^$jsinject,extension` → `@@||pilet.elron.ee^$jsinject`

### $urlblock (5 rules - all whitelists @@)
- **Purpose**: Whitelists domains from URL blocking
- **Decision**: **STRIP** - eBlocker doesn't have URL blocking feature
- **Example**: `@@||kiwihousesitters.co.nz/members$urlblock` → `@@||kiwihousesitters.co.nz/members`

### $content (12 rules - all whitelists)
- **Purpose**: Content type filtering whitelist
- **Decision**: **STRIP** - Generic whitelist should work
- **Example**: `@@||telegram.hr^$content` → `@@||telegram.hr^`

### $match-case (2 rules)
- **Purpose**: Makes pattern matching case-sensitive
- **Decision**: **STRIP** - eBlocker regex is case-sensitive by default
- **Example**: `||nuvid.com/NB*.js$match-case` → `||nuvid.com/NB*.js`

---

## DELETE ENTIRE RULE (functionality requires features eBlocker doesn't have):

### $jsonprune (25 rules)
- **Purpose**: Removes properties from JSON API responses
- **Example**: `/GetVodPlaybackResources?$jsonprune=\$.vodPlaybackUrls.result.playbackUrls.cuepoints`
- **Reason**: eBlocker can't parse/modify JSON responses
- **Decision**: **DELETE**

### $cookie (21 rules)
- **Purpose**: Blocks or modifies cookie headers
- **Example**: `$cookie=__adblocker,domain=slate.com`
- **Reason**: eBlocker doesn't filter cookie headers
- **Decision**: **DELETE**

### $jsinject (19 rules - all whitelists)
- **Purpose**: Allows JavaScript injection on whitelisted domains
- **Example**: `@@://www.bet365.com/|$jsinject,elemhide`
- **Reason**: eBlocker doesn't inject JavaScript
- **Decision**: **DELETE** (or STRIP if combined with supported modifiers)

### $app (12 rules)
- **Purpose**: Application-specific rules (GOM.exe, Skype.exe)
- **Example**: `||playinfo.gomlab.com^$app=GOM.exe`
- **Reason**: eBlocker doesn't know which app is making requests
- **Decision**: **DELETE**

### $removeparam (11 rules)
- **Purpose**: Removes tracking parameters from URLs
- **Example**: `||player.octivid.com/*/video?*&custom_ads=$removeparam=custom_ads`
- **Reason**: eBlocker can't rewrite URLs
- **Decision**: **DELETE**

### $hls (5 rules)
- **Purpose**: Filters HLS video stream manifests (.m3u8) to remove ads
- **Example**: `||prism.a2d.tv/hls/media/*.m3u8?$hls=/https:\/\/prism-ads-cdn\.a2d\.tv\//`
- **Reason**: eBlocker can't parse/modify streaming manifests
- **Decision**: **DELETE**

### $referrerpolicy (4 rules)
- **Purpose**: Modifies Referrer-Policy HTTP header
- **Example**: `||yallo.tv^$referrerpolicy=origin`
- **Reason**: eBlocker doesn't modify HTTP headers
- **Decision**: **DELETE**

### $urltransform (3 rules)
- **Purpose**: Transforms/rewrites URLs using regex
- **Example**: `://content-loader.com/loader.min.js$urltransform=/loader\.min\.js/error.js/`
- **Reason**: eBlocker can't rewrite URLs
- **Decision**: **DELETE**

### $removeheader (3 rules)
- **Purpose**: Removes HTTP response headers
- **Example**: `||go.goasrv.com^$removeheader=location`
- **Reason**: eBlocker doesn't modify HTTP headers
- **Decision**: **DELETE**

### $xmlprune (2 rules)
- **Purpose**: Prunes DASH/XML manifests to remove ad periods
- **Example**: `.mpd$xmlprune=//*[name()="Period"][.//*[@value="Ad"]]`
- **Reason**: eBlocker can't parse/modify XML manifests
- **Decision**: **DELETE**

### $rpc (2 rules)
- **Purpose**: Filters gRPC/Protobuf calls
- **Example**: `@@||alkalimetricsink-pa.clients6.google.com/$rpc/google.internal.alkali`
- **Reason**: eBlocker doesn't understand gRPC
- **Decision**: **DELETE**

---

## Summary:

**Rules to keep (strip modifier only)**: ~1,523
- Mostly whitelists where the modifier isn't critical
- $stealth, $extension, $urlblock, $content, $match-case

**Rules to delete entirely**: ~95
- Advanced features eBlocker can't support
- $jsonprune, $cookie, $jsinject, $app, $removeparam, $hls, $referrerpolicy, $urltransform, $removeheader, $xmlprune, $rpc

**Total cleanup**: ~1,618 rules affected (2% of filter)
**Result**: ~78,100 clean eBlocker-compatible rules
