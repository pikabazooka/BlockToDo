import 'package:flutter/material.dart';
import 'util/checkbox_state.dart';


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  List todoList=[
    ["Finish Assignment",false],
    ["Clean up room",true]
  ];
  void checkBoxChanged(bool? value, int index){
    setState(() {
      todoList[index][1]=!todoList[index][1];
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodoBlocks(taskName: todoList[index][0], taskCompleted: todoList[index][1], onChanged:(value)=>checkBoxChanged(value,index),);
        }
      ),
    );
  }
}

