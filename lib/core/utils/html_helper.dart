/// Utilidades para procesar HTML simple.
class HtmlHelper {
  /// Convierte un texto HTML en texto plano básico.
  ///
  /// Esto es útil mientras estás probando en web o escritorio
  /// sin depender todavía de una vista HTML completa.
  static String stripHtmlTags(String html) {
    final withoutBreaks = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'</div>', caseSensitive: false), '\n');

    final withoutTags = withoutBreaks.replaceAll(RegExp(r'<[^>]*>'), '');

    return withoutTags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', '\'')
        .trim();
  }
}