import 'package:logger/logger.dart';

class CustomPrinter extends LogPrinter {
  final Map<Level, String> levelColors = {
    Level.verbose: '\x1B[37m', // Trắng
    Level.debug: '\x1B[34m', // Xanh dương
    Level.info: '\x1B[32m', // Xanh lá
    Level.warning: '\x1B[33m', // Vàng
    Level.error: '\x1B[31m', // Đỏ
    Level.wtf: '\x1B[35m', // Tím
  };

  @override
  List<String> log(LogEvent event) {
    final color = levelColors[event.level] ?? '\x1B[0m'; // * default color
    final message = event.message;
    return ['$color$message\x1B[0m'];
  }
}
