// import 'package:bubble/bubble.dart';
// import 'package:flutter/material.dart';
//
// import 'package:chat_app_mobile_fe/models/message.dart';
//
// class MessageBubbleWidget extends StatefulWidget {
//   final Message message;
//
//   const MessageBubbleWidget({super.key, required this.message});
//
//   @override
//   State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
// }
//
// class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment:
//           widget.message.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Bubble(
//         margin: const BubbleEdges.symmetric(horizontal: 7, vertical: 4),
//         padding: const BubbleEdges.symmetric(vertical: 0, horizontal: 0),
//         // nip is used to adjust the position of sharp corners
//         nip: widget.message.isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
//         color: widget.message.isMe
//             ? const Color(0xFF07593B)
//             : const Color(0xFF222D33),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Text(
//             widget.message.text,
//             style: const TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
