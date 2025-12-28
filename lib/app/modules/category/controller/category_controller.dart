import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';

class CategoryController extends GetxController {
  final AppDb database = Get.find<AppDb>();

  var categoryList = <Category>[].obs;
  var isExpense = true.obs;

  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final int type = isExpense.value ? 2 : 1;
    categoryList.value = await database.getAllCategoriesRepo(type);
  }

  Future<void> insert(String name) async {
    final now = DateTime.now();
    await database.into(database.categories).insert(
      CategoriesCompanion.insert(
        name: name,
        type: isExpense.value ? 2 : 1,
        createdAt: now,
        updateAt: now,
      ),
    );
    fetchCategories();
  }

  Future<void> updateCategory(int id, String newName) async {
    await database.updateCategoryRepo(id, newName);
    fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await database.deleteCategoryRepo(id);
    fetchCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
