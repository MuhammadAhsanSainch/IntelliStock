import 'package:get/get.dart';
import 'package:intelli_Stock/model/data/database_helper.dart';
import 'package:intelli_Stock/model/models/inventory_item.dart';

class InventoryItemViewModel extends GetxController {
  final dbHelper = DatabaseHelper();

  final itemList = <InventoryItem>[].obs;

  Future<void> addItem(
      var name,
      var imagePath,
      var barcode,
      var purchasePrice,
      var salesPrice,
      var unit,
      var openingStock,
      var dateTime,
      var pricePerUnit,
      var totalValue,
      var minOrderQty) async {
    final item = InventoryItem(
      id: await dbHelper.getId(),
      name: name,
      imagePath: imagePath,
      barcode: barcode,
      purchasePrice: purchasePrice,
      salesPrice: salesPrice,
      unit: unit,
      openingStock: openingStock,
      dateTime: dateTime,
      pricePerUnit: pricePerUnit,
      totalValue: totalValue,
      minOrderQty: minOrderQty,
    );
    await dbHelper.insertItem(item);
    getItemList();
  }

  Future<void> updateItem(InventoryItem updatedItem) async {
    await dbHelper.updateItem(updatedItem);
    getItemList();
  }

  Future<void> deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    getItemList();
  }

  void getItemList() async {
    final items = await dbHelper.getAllItems();
    itemList.value = items;
  }
}
