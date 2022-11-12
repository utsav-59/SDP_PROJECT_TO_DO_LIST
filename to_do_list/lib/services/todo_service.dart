import 'package:to_do_list/models/todo.dart';
import 'package:to_do_list/repositories/repositories.dart';

class TodoService{
Repository _repository;
TodoService(){
  _repository = Repository();
}

//Create todos
saveTodo(Todo todo) async{
  return await _repository.insertData('todos', todo.todoMap());
}

//read todos
readTodos() async {
  return await _repository.readData('todos');
}

  readTodosByCategory(category) async {
    return await _repository?.readDataByColumnName("todos", "category", category);

  }
}