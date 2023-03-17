import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String title;
  VoidCallback func;

  CustomButton({required this.title, required this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180,
        child: ElevatedButton(
            onPressed: func,
            child: Row(
              children: [
                const Icon(Icons.image_outlined),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  textAlign: TextAlign.left,
                ),
              ],
            )));
  }
}
