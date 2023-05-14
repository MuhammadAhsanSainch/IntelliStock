import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intelli_Stock/model/models/inventory_item.dart';
import 'package:intelli_Stock/view/manage_products_screens.dart';
import 'package:intelli_Stock/view_model/inventory_item_view_model.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  // final InventoryItemController _itemController =
  //     Get.put(InventoryItemController());
  final inventoryItemViewModel = Get.put(InventoryItemViewModel());
  final idController = TextEditingController();
  @override
  void initState() {
    super.initState();
    inventoryItemViewModel.getItemList();
    inventoryItemViewModel.itemList;
    // Provider.of<ItemProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // ItemProvider items = ItemProvider();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
      ),
      body: Obx(() => ListView.builder(
          itemCount: inventoryItemViewModel.itemList.length,
          itemBuilder: (context, index) {
            final item = inventoryItemViewModel.itemList[index];
            return ListTile(
              leading: Text(item.id.toString()),
              //     TextFormField(
              //   readOnly: true,
              //   initialValue: item.id.toString(),
              //   onSaved: (newValue) {
              //     idController.text = newValue.toString();
              //   },
              // ),
              title: Text(item.name),
              subtitle: Text('\$${item.salesPrice}'),
              trailing: IconButton(
                  onPressed: () {
                    inventoryItemViewModel.deleteItem(item.id);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)),
              onTap: () {
                _navigateToEditScreen(context, item.id.toString(), item);
              },
            );
          })),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'Create New Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _navigateToAddScreen(context);
        },
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToAddScreen(BuildContext context) {
    Get.to(() => const AddInventoryItem(isEditMode: false));
  }

  void _navigateToEditScreen(
      BuildContext context, String id, InventoryItem item) {
    Get.to(() => AddInventoryItem(
          isEditMode: true,
          item: item,
          leadingValue: id,
        ));
  }
}
