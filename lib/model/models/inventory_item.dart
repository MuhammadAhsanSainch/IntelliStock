// This is the code for the InventoryItem model class, which represents the
//data structure of a InventoryItem object in the app.
//The InventoryItem class has following properties

class InventoryItem {
  int id;
  String name;
  //Uint8List itemImage;
  String imagePath;
  String barcode;
  double purchasePrice;
  double salesPrice;
  String unit;
  double openingStock;
  String dateTime;
  double pricePerUnit;
  double totalValue;
  double minOrderQty;

// The id property is nullable because it will be assigned by the
//database when an inventory item is inserted, while the other properties are
//required and must be provided when creating a new instance
// of the InventoryItem class.

  InventoryItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.barcode,
    required this.purchasePrice,
    required this.salesPrice,
    required this.unit,
    required this.openingStock,
    required this.dateTime,
    required this.pricePerUnit,
    required this.totalValue,
    required this.minOrderQty,
  });

// The class has two methods: toMap and fromMap.

// The toMap method converts a InventoryItem object into
//a map, which can be easily stored in a SQLite database.
//The map has keys corresponding to the database
//columns and values corresponding to the InventoryItem
//object's properties.

  Map<String, dynamic> toMap() {
    //this method will be used while inserting record
    return {
      'id': id == 0 ? id += 1 : id,
      'name': name,
      'imagePath': imagePath,
      'barcode': barcode,
      'purchasePrice': purchasePrice,
      'salesPrice': salesPrice,
      'unit': unit,
      'openingStock': openingStock,
      'dateTime': dateTime,
      'pricePerUnit': pricePerUnit,
      'totalValue': totalValue,
      'minOrderQty': minOrderQty
    };
  }

// The fromMap method does the opposite; it takes in a map
//and returns a InentoryItem object with the properties
//set based on the map's values. This method is useful
//when retrieving data from the database and converting it
//back to a Book object.

  static InventoryItem fromMap(Map<dynamic, dynamic> map) {
    return InventoryItem(
        id: map['id'],
        name: map['name'],
        imagePath: map['imagePath'],
        barcode: map['barcode'],
        purchasePrice: map['purchasePrice'],
        salesPrice: map['salesPrice'],
        unit: map['unit'],
        openingStock: map['openingStock'],
        dateTime: map['dateTime'],
        pricePerUnit: map['pricePerUnit'],
        totalValue: map['totalValue'],
        minOrderQty: map['minOrderQty']);
  }
}
