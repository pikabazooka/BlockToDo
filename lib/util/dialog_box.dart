import 'package:flutter/material.dart';
import 'package:flutter_application_2/component/button.dart';

// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancle;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancle,
  });
  @override 
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF7FC7D9),
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Add task",
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(text: "Save", onPressed: onSave),
              const SizedBox(width: 8),
              MyButton(text: "Cancel", onPressed: onCancle),
            ],
          )
        ],)
      ),
    );
  }
}