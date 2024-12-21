import 'dart:math';

class GeneratorUtil {
  static String generateRandomString(int length) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static String generateUniqueFileName(String originalPath) {
    final fileName = originalPath.split('/').last;
    final name = fileName.split('.').first;
    final extension = fileName.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    return '${name}_$timestamp.$extension';
  }
}
