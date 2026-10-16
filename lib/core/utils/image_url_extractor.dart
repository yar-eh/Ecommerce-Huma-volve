/// Cleans image URLs coming from the API.
/// Some products return messy values like `["https://..."]` or broken strings,
/// so we pull out every valid http(s) URL and drop the rest.
class ImageUrlExtractor {
  ImageUrlExtractor._();

  static final RegExp _urlRegex = RegExp(r'https?://[^\s"\[\]\\]+');

  static List<String> extractValidUrls(List<String> rawImages) {
    final List<String> validUrls = [];

    for (final raw in rawImages) {
      final str = raw.trim();
      if (str.isEmpty) continue;

      for (final match in _urlRegex.allMatches(str)) {
        final url = match.group(0)!.replaceAll(RegExp(r'[,.]+$'), '').trim();
        if (_isValidImageUrl(url) && !validUrls.contains(url)) {
          validUrls.add(url);
        }
      }
    }
    return validUrls;
  }

  static bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    return uri.host.isNotEmpty;
  }
}
