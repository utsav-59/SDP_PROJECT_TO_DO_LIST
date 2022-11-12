import 'package:to_do_list/repositories/repositories.dart';
import '../models/category.dart';

class CategoryService{
   Repository _repository;

   CategoryService(){
     _repository = Repository();
   }

   //Create Data
  saveCategory(Category category) async {
    return await _repository?.insertData('categories', category.categoryMap());

}
//read data from table
readCategories() async{
     return await _repository?.readData('categories');
}
//read table data  by Id
  readCategoryById(categoryId) async {
     return await _repository?.readDataById('categories',categoryId);

  }
// Update data from tale
  updateCategory(Category category) async {
     return await _repository.updateData('categories',category.categoryMap());
  }
//Delete data from table
  deleteCategory(categoryId) async{
     return await _repository.deleteData('categories',categoryId);
  }
}