import 'package:to_do_list/models/todo.dart';
import 'package:to_do_list/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/services/todo_service.dart';
import 'package:to_do_list/models/message.dart';

class TodoScreen extends StatefulWidget {
  //const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _categories = <DropdownMenuItem>[];
  var _selectedValue;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async{
    var _categoryservice = CategoryService();
    var categories = await _categoryservice.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category['name']),
          value:category['name'],
        ));
      });
    });
  }
  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  // _showSuccessSnackBar(message){
  //   var _snackBar = SnackBar(content: message);
  //   _globalKey.currentState.showSnackBar(_snackBar);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Create Todo List Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write Todo Title',
                  ),
              ),
            TextField(
              controller: _todoDescriptionController ,
              decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write Todo Description'
              ),
            ),
            TextField(
              controller: _todoDateController ,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Choose a Date',
                     prefixIcon: InkWell(
                      onTap: (){
                        _selectedTodoDate(context);
                      },
                       child: Icon(Icons.calendar_today_outlined),
              ),
            ),
            ),
            DropdownButtonFormField(
                value: _selectedValue,
                items: _categories,
                hint:  Text('Category'),
                onChanged: (value){
                  setState(() {
                      _selectedValue = value;
                  });
                },
            ),
                  SizedBox(
                    height: 20,
                    ),
          TextButton(
            onPressed:() async {
              var todoObject = Todo();

              todoObject.title = _todoTitleController.text;
              todoObject.description = _todoDescriptionController.text;
              todoObject.isFinished=0;
              todoObject.category=_selectedValue.toString();
              todoObject.todoDate = _todoDateController.text;


              var _todoService = TodoService();
              var result = await _todoService.saveTodo(todoObject);
              if(result > 0 ) {
                //print(result);
                GlobalSnackBar.show(context,"Created Successfully!");
                Navigator.pop(context);
              }

            },
            child: Text('Save'),
            style: TextButton.styleFrom(
              primary:Colors.white,
                backgroundColor:Colors.blueAccent,
            ),
          )
          ],
        ),
      ),
    );
  }
}
