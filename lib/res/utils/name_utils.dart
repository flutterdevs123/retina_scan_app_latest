/// Small helpers for working with person names.
class NameUtils {
  NameUtils._();

  /// Returns up to two letters, e.g. "Ali Raza" -> "AR".
  /// The "Dr." title is ignored, so "Dr. Sara Malik" -> "SM".
  static String initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) {
      final String lower = p.toLowerCase();
      return p.isNotEmpty && lower != 'dr.' && lower != 'dr';
    })
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}