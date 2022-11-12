import 'package:flutter/material.dart';
import 'package:to_do_list/models/category.dart';
import 'package:to_do_list/screens/home_screen.dart';
import 'package:to_do_list/services/category_service.dart';
import 'package:to_do_list/models/message.dart';


class CategoriesScreen extends StatefulWidget {
 // const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();


  @override
  void initState(){
    super.initState();
    getAllCategories();
  }
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  List<Category> _categoryList = <Category>[];
 // var _categoryList = List<String>.Category();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.id = category['id'];
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];

        _categoryList.add(categoryModel);
      });
    }
    );

  }
  _editCategory(BuildContext context,categoryId) async {
category = await _categoryService.readCategoryById(categoryId);
setState(()
{
  _editCategoryNameController.text = category[0]['name']??'No Name';
  _editCategoryDescriptionController.text = category[0]['description']??'No Description';
    });
  _editFormDialog(context);
  }

  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true,builder: (param)  {
      return AlertDialog(
        actions: <Widget>[

          TextButton(onPressed: () => Navigator.pop(context), child:Text('Cancel'),
            style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor:Colors.redAccent // Text Color
          ),
          ),
          TextButton(onPressed: () async {
           _category.name = _categoryNameController.text;
           _category.description = _categoryDescriptionController.text;

           var result = await _categoryService.saveCategory(_category);
           if(result > 0){
             print(result);
             Navigator.pop(context);
             getAllCategories();
           }
          }, child:Text('Save'),  style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blueAccent// Text Color
          ),
          ),
        ],


        title: Text('Categories Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write a category',
                  labelText:  ' Add Category'
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText:  'Description'

                ),
              ),
            ],
          ),
        ),
      );
  });
}

  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true,builder: (param)  {
      return AlertDialog(
        actions: <Widget>[

          TextButton(onPressed: () => Navigator.pop(context), child:Text('Cancel'),  style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor:Colors.redAccent // Text Color
          ),
          ),
          TextButton(onPressed: () async {
            _category.id = category[0]['id'];
            _category.name = _editCategoryNameController.text;
            _category.description = _editCategoryDescriptionController.text;

            var result = await _categoryService.updateCategory(_category);
            if(result > 0){
              print(result);
              Navigator.pop(context);
              getAllCategories();
              //_showSuccessSnackBar(Text('Updated'));
            }
          },
            child:Text('Update'),  style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blueAccent// Text Color
          ),
          ),
        ],


        title: Text('Edit Categories Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editCategoryNameController,
                decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText:  ' Add Category'
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText:  'Description'

                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  var result =
                  await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    // print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    GlobalSnackBar.show(context, 'Deleted');
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text('Confirm to Delete!'),
          );
        });
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
        leading: ElevatedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(Icons.arrow_back),

      ),
        title: Text('Categories'),
      ),
      body: ListView.builder(
          itemCount:_categoryList.length,itemBuilder: (context,index){
            return Padding(
              padding: EdgeInsets.only(top:8.0,left:16.0,right:16.0),
              child:Card(
                elevation: 8.0,
                  child:ListTile(
                    textColor:Colors.deepOrangeAccent,
                   trailing:IconButton(onPressed: (){
                     _editCategory(context, _categoryList[index].id);
                      },
                      icon: Icon(Icons.edit),
                      color: Colors.greenAccent),

                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                      Text(_categoryList[index].name),
                      IconButton(
                      icon: Icon(
                      Icons.delete,
                      color: Colors.blueAccent,
                ),
                  onPressed: (){
                        _deleteFormDialog(context,_categoryList[index].id);
                  })
              ],
            ),
          ),
              )
        );

      }),

      floatingActionButton: FloatingActionButton(onPressed: () {
        _showFormDialog(context);
      },child: Icon(Icons.add),
      ),
    );
  }
}
