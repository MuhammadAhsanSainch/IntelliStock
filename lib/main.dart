import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intelli_Stock/view/manage_products_screens.dart';
import 'package:intelli_Stock/view/products_list_screen.dart';
import 'package:intelli_Stock/view_model/inventory_item_view_model.dart';

import 'model/data/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final dbHelper = DatabaseHelper();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<InventoryItemViewModel>(() => InventoryItemViewModel());
      }),
      // initialRoute: 'add_inventory_Item',
      initialRoute: 'products_List',
      getPages: [
        GetPage(
            name: '/add_inventory_Item',
            page: () => const AddInventoryItem(
                  isEditMode: false,
                )),
        GetPage(name: '/products_List', page: () => const ProductsList())
      ],
    );
  }
}
