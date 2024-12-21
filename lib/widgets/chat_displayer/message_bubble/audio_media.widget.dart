import 'dart:math';

import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final Widget createdAt;
  final Widget messageState;

  const AudioMessageWidget({
    super.key,
    required this.audioUrl,
    required this.createdAt,
    required this.messageState,
  });

  @override
  _AudioMessageWidgetState createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget>
    with SingleTickerProviderStateMixin {
  final logger = Logger(printer: CustomPrinter());
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  late AnimationController _waveController;
  final List<double> _waveHeights = [];
  bool _isPlaying = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Lắng nghe trạng thái phát nhạc
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
        
        // Kiểm tra khi audio kết thúc
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _isCompleted = true;
          _currentPosition = _audioDuration;
        }
      });
    });

    // Lắng nghe vị trí hiện tại của audio
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
      setState(() {
        _audioDuration = _audioPlayer.duration ?? Duration.zero;
      });
    } catch (e) {
      logger.e("Error loading audio: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể tải âm thanh: $e")),
      );
    }
  }

  Future<void> _handlePlayAudio() async {
    try {
      // Nếu audio đã hoàn thành, reset về ban đầu
      if (_isCompleted) {
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
        setState(() {
          _isCompleted = false;
          _currentPosition = Duration.zero;
        });
        return;
      }

      // Nếu đang phát, tạm dừng
      if (_isPlaying) {
        await _audioPlayer.pause();
      } 
      // Nếu đang tạm dừng, tiếp tục phát
      else {
        await _audioPlayer.play();
      }
    } catch (e) {
      logger.e("Error playing/pausing audio: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể phát âm thanh")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(
                // Logic hiển thị icon
                _isCompleted 
                  ? Icons.replay 
                  : (_isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
              ),
              onPressed: _handlePlayAudio,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 20,
                child: CustomPaint(
                  painter: AudioWavePainter(
                    progress: _currentPosition.inMilliseconds /
                        _audioDuration.inMilliseconds,
                    initialHeights: _waveHeights,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDuration(_audioDuration - _currentPosition),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _waveController.dispose();
    super.dispose();
  }
}


class AudioWavePainter extends CustomPainter {
  final double progress;
  final List<double> heights; // Lưu trữ các giá trị chiều cao cố định

  AudioWavePainter({
    this.progress = 0.0,
    List<double>? initialHeights, // Thêm tham số để truyền heights từ bên ngoài
  }) : heights = initialHeights ?? []; // Khởi tạo heights

  @override
  void paint(Canvas canvas, Size size) {
    final paintInactive = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2;

    final paintActive = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    // Tạo heights một lần nếu chưa có
    if (heights.isEmpty) {
      final random = Random();
      final rawHeights = List.generate(
        (size.width ~/ 4).toInt(),
        (index) => random.nextDouble() * size.height,
      );

      // Làm mượt các giá trị
      for (int i = 0; i < rawHeights.length; i++) {
        double avgHeight = rawHeights[i];
        int count = 1;

        if (i > 0) {
          avgHeight += rawHeights[i - 1];
          count++;
        }
        if (i < rawHeights.length - 1) {
          avgHeight += rawHeights[i + 1];
          count++;
        }

        heights.add(avgHeight / count);
      }
    }

    // Vẽ các đường với chiều cao cố định
    for (int i = 0; i < heights.length; i++) {
      final x = i * 4.0;
      final height = heights[i];

      final startY = size.height / 2 - height / 2;
      final endY = size.height / 2 + height / 2;

      final paint =
          (i / heights.length) < progress ? paintActive : paintInactive;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
