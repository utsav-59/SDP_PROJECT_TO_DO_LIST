import 'package:flutter/material.dart';
import 'package:to_do_list/helpers/drawer_navigation.dart';
import 'package:to_do_list/models/todo.dart';
import 'package:to_do_list/screens/todo_screen.dart';
import 'package:to_do_list/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todoList = <Todo>[];
  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = <Todo>[];

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];

        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO DO LIST"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: dead_null_aware_expression
                  children: <Widget>[
                    Text(_todoList[index].title ?? 'No Title')
                  ],
                ),
                subtitle: Text(_todoList[index].category ?? 'No Category'),
                trailing: Text(_todoList[index].todoDate ?? 'No Date'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen())),
          child: Icon(Icons.add)),
    );
  }
}


