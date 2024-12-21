import 'dart:async';
import 'dart:io';

import 'package:chat_app_mobile_fe/services/chat.services.dart';
import 'package:chat_app_mobile_fe/utils/check_date.util.dart';
import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:chat_app_mobile_fe/utils/path.util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String, String?) onSendTextMessage;
  final Future<void> Function({required File file, required String type})
      onSendAudioMessage;
  final Future<void> Function() onPickFile;

  const InputWidget({
    super.key,
    required this.messageController,
    required this.onSendTextMessage,
    required this.onSendAudioMessage,
    required this.onPickFile,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final logger = Logger(printer: CustomPrinter());
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInputEmpty = true;
  bool _isRecording = false;
  bool _isPause = true;
  Timer? _timerForRecording;
  int _elapsedSecond = 0;

  @override
  void initState() {
    super.initState();

    _initRecorder();
    widget.messageController.addListener(_checkInputStatus);
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_checkInputStatus);
    widget.messageController.dispose();
    _recorder.closeRecorder();

    super.dispose();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception("Không có quyền sử dụng microphone");
    }
    await _recorder.openRecorder();
  }

  void _checkInputStatus() {
    setState(() {
      _isInputEmpty = widget.messageController.text.trim().isEmpty;
    });
  }

  void _startTimer() {
    _timerForRecording = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSecond++;
      });
    });
  }

  void _cancelTimer() {
    _timerForRecording?.cancel();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      await widget.onPickFile();
    }
  }

  Future<void> _startRecording() async {
    try {
      await _initRecorder();
      setState(() {
        _isRecording = true;
        _isPause = true;
      });
      final recordingPath = await PathUtil.createAudioPath();

      logger.w("==================================");
      logger.i("_startRecording");
      logger.i(recordingPath);
      logger.w("==================================");

      await _recorder.startRecorder(toFile: recordingPath);
    } catch (e) {
      logger.e("Lỗi khi bắt đầu ghi âm: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (_isRecording) {
        final path = await _recorder.stopRecorder();

        _cancelTimer();
        setState(() {
          _elapsedSecond = 0;
          _isRecording = false;
          _isPause = true;
        });

        logger.w("==================================");
        logger.i("_stopRecording");
        logger.i(path);
        logger.w("==================================");

        await _recorder.stopRecorder();

        final audioFile = File(path!);

        widget.onSendAudioMessage(file: audioFile, type: "audio");
      }
    } catch (e) {
      logger.e("Lỗi khi dừng ghi âm: $e");
    }
  }

  void _onSendOrRecord() {
    if (_isInputEmpty) {
      if (!_isRecording) {
        _startTimer();
        _startRecording();
      } else {
        _cancelTimer();
        _stopRecording();
      }
    } else {
      widget.onSendTextMessage(widget.messageController.text, null);
      widget.messageController.clear();
    }
  }

  Future<void> _pauseRecording() async {
    try {
      if (_isRecording) {
        await _recorder.pauseRecorder();
        _cancelTimer();
        setState(() {
          _isPause = false;
        });
      }
    } catch (e) {
      logger.e("Lỗi khi tạm dừng ghi âm: $e");
    }
  }

  Future<void> _resumeRecording() async {
    try {
      if (_isRecording) {
        await _recorder.resumeRecorder();
        _startTimer();
        setState(() {
          _isPause = true;
        });
      }
    } catch (e) {
      logger.e("Lỗi khi tiếp tục ghi âm: $e");
    }
  }

  void _handlePause() async {
    if (!_isPause) {
      await _resumeRecording();
    } else {
      await _pauseRecording();
    }
  }

  Future<void> _cancelRecording() async {
    try {
      if (_isRecording) {
        final path = await _recorder.stopRecorder();
        if (path != null) {
          await PathUtil.deleteFile(path);
        }

        _cancelTimer();
        setState(() {
          _elapsedSecond = 0;
          _isRecording = false;
          _isPause = true;
        });
      }
    } catch (e) {
      logger.e("Lỗi khi hủy ghi âm: $e");
    }
  }

  Widget _buildRecordingWidget() {
    return Row(
      children: [
        // Bin
        IconButton(
          icon: const Icon(Icons.delete, color: Color(0xFFB7B7B7)),
          onPressed: _cancelRecording,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF31363F),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: [
                // Pause
                if (_isPause)
                  IconButton(
                    icon: const Icon(
                      Icons.pause,
                      color: Color(0xFFB7B7B7),
                    ),
                    onPressed: _handlePause,
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color(0xFFB7B7B7),
                    ),
                    onPressed: _handlePause,
                  ),
                // Progress
                Expanded(
                  child: Container(
                    height: 2,
                    color: const Color(0xFF00FF9C),
                  ),
                ),
                // Show time
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StreamBuilder<RecordingDisposition>(
                    stream: _recorder.onProgress,
                    builder: (context, snapshot) {
                      return Text(
                        CheckDate.formatDuration(_elapsedSecond),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                // // Nút play/next
                // IconButton(
                //   icon: const Icon(
                //     Icons.play_arrow,
                //     color: Color(0xFF00FF9C),
                //   ),
                //   onPressed: () {}, // Xử lý play/next
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          // Hiển thị nút đính kèm file nếu không ghi âm
          if (!_isRecording) 
            IconButton(
              icon: const Icon(
                Icons.attach_file,
                color: Color(0xFFB7B7B7),
              ),
              onPressed: _pickFile,
            ),
          Expanded(
            child: _isRecording
                ? _buildRecordingWidget() // Widget hiển thị khi đang ghi âm
                : TextField(
                    controller: widget.messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nhắn tin',
                      hintStyle: const TextStyle(color: Color(0xFFB7B7B7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF31363F),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Color(0xFFB7B7B7),
                        ),
                        onPressed: () {}, // Mở emoji picker
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: _onSendOrRecord,
            backgroundColor: const Color(0xFF00FF9C),
            mini: true,
            child: Icon(
              _isInputEmpty
                  ? (_isRecording ? Icons.send : Icons.mic)
                  : Icons.send,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
