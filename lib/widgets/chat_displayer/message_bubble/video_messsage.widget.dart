import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoMessageWidget extends StatefulWidget {
  final String? fileUrl;
  final Widget createdAt;
  final Widget messageState;

  const VideoMessageWidget({
    super.key,
    required this.fileUrl,
    required this.createdAt,
    required this.messageState,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VideoMessageWidgetState createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;
  bool _isUploading = true;

  @override
  void initState() {
    super.initState();
    if (widget.fileUrl != null) {
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.fileUrl!);
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
        _isUploading = false;
      });
    } catch (_) {
      setState(() {
        _hasError = true;
        _isUploading = false;
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                : _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : _chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : const Center(child: Text('Chưa có video')),
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
