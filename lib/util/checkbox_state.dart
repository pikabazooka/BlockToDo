// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TodoBlocks extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;

  TodoBlocks({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged
    });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:25, right:25, top:25),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFDCF2F1),
          borderRadius:BorderRadius.circular(12) 
        ),
        child: Row(
          children: [
            Checkbox(value: taskCompleted, onChanged: onChanged,activeColor: Color(0xFF0F1035),),

            Text(
              taskName,
              style:TextStyle(decoration: taskCompleted? TextDecoration.lineThrough:TextDecoration.none, color:const Color(0xFF0F1035)),
            ),
          ],
        ),
      ),
    );
  }
}