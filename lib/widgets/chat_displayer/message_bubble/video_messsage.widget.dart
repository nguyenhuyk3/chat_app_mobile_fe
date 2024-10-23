import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoMessageWidget extends StatefulWidget {
  final String fileUrl;
  final Widget createdAt;
  final Widget messageState;

  const VideoMessageWidget({
    Key? key,
    required this.fileUrl,
    required this.createdAt,
    required this.messageState,
  }) : super(key: key);

  @override
  _VideoMessageWidgetState createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.fileUrl);

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.hasError) {
          setState(() {
            _hasError = true;
          });
        }
      });

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 9 / 16,
        autoPlay: false,
        looping: false,
      );

      setState(() {
        _hasError = false;
      });
    } catch (_) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 9 / 16,
            child: _hasError
                ? const Center(
                    child: Text(
                      'Lỗi hiển thị video',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                widget.createdAt,
                const SizedBox(width: 4),
                widget.messageState,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
