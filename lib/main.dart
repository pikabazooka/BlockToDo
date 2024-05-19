import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/inventory.dart';
import 'package:flutter_application_2/leaderboard.dart';
import 'package:flutter_application_2/login.dart';
import 'package:flutter_application_2/todo.dart';
import 'package:flutter_application_2/util/dialog_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF365486)),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage=0;

  List<Widget> pages = const [
    TodoPage(),
    InventoryPage(),
    LeaderboardPage()
  ];

  final _controller = TextEditingController();
  
  get todoList => null;
  
  
  void saveNewTask() {
    setState(() {
      todoList.add([ _controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  //new task
  void createNewTask() { 
    showDialog(context: context, builder: (context){
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancle: () => Navigator.of(context).pop(),
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 65, 92, 139),
        title: const Text('To-Do List',style: TextStyle(color:Color.fromARGB(255, 202, 203, 226)),),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context){
                return const LoginPage();
              }
              )
            );
          }, icon: const Icon(Icons.person, color: Color.fromARGB(255, 202, 203, 226),))
        ],
      ),
      body: pages[currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask, 
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'To-Do'),
          NavigationDestination(icon: Icon(Icons.add_box_rounded), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        ],
        onDestinationSelected: (int index){
          setState(() {
            currentPage=index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
