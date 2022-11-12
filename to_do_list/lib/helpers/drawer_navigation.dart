import 'package:flutter/material.dart';
import 'package:to_do_list/screens/todos_by_category.dart';
import 'package:to_do_list/services/category_service.dart';
import '../screens/categories_screen.dart';
import '../screens/home_screen.dart';


class DrawerNavigation extends StatefulWidget {
  //const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  List<Widget> _categoryList = <Widget>[];
  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
            onTap: ()=>Navigator.push(context,new MaterialPageRoute(builder: (context)=> TodosByCategory(category: category['name'],))),
            child:ListTile(
              title: Text(category['name']),
            )),);
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:NetworkImage('https://picsum.photos/200/300'),
              ),
                accountName: Text('Utsav Sheth'),
                accountEmail: Text('abcd@gmail.com'),
                decoration: BoxDecoration(color: Colors.blueAccent)
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => HomeScreen())),
              textColor:Colors.amber,
              iconColor:Colors.amberAccent,
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Category'),
                textColor:Colors.amber,
                iconColor:Colors.amberAccent,
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder:(context) => CategoriesScreen()))),
            // ListTile(
            //     //leading: Icon(Icons.view_list),
            //   leading: Icon(Icons.lens),
            //     title: Text('Logout'),
            //     textColor:Colors.blueAccent,
            //     iconColor:Colors.blue,
            //     onTap: (){} ),
            Divider(),
            Column(
              children:_categoryList
            ),
          ],
        ),
      ),
    );
  }
}
