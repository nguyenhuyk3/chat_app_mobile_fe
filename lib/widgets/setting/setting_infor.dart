import 'package:flutter/material.dart';

class MySettingInfor extends StatefulWidget {
  const MySettingInfor({super.key});

  @override
  State<MySettingInfor> createState() => _MySettingInforState();
}

class _MySettingInforState extends State<MySettingInfor> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 0.08, color: Colors.white),
                bottom: BorderSide(width: 0.08, color: Colors.white))),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Huỳnh Minh Cường',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Xin chào! đến với Ping ME',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 80),
                child: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.green,
                ))
          ],
        ),
      ),
    );
  }
}
