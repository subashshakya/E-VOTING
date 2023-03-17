import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  String title;
  VoidCallback func;
  IconData iconName;

  HomeButton({required this.title, required this.func, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        alignment: Alignment.center,
        height: 100,
        child: ElevatedButton(
            onPressed: func,
            child: Row(
              children: [
                Icon(iconName),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            )));
  }
}
