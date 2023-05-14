import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:intelli_Stock/model/data/database_helper.dart';
import 'package:intelli_Stock/model/models/inventory_item.dart';
import 'package:intelli_Stock/model/res/components.dart';
import 'package:intelli_Stock/view/products_list_screen.dart';
import 'package:intelli_Stock/view_model/inventory_item_view_model.dart';

class AddInventoryItem extends StatefulWidget {
  final bool isEditMode;
  final String leadingValue;
  final InventoryItem? item;
  const AddInventoryItem(
      {super.key, required this.isEditMode, this.item, this.leadingValue = ''});

  @override
  State<AddInventoryItem> createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends State<AddInventoryItem> {
  final dbHelper = DatabaseHelper();
  final _itemNameController = TextEditingController();
  File? _image; // = File('images/image.jpg');
  final _picker = ImagePicker();
  final _barcodeController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salesPriceController = TextEditingController();
  final _pricePerUnitController = TextEditingController(text: '0');
  String _selectedOption = 'Packet';
  final List<String> _options = [
    'Kilogram',
    'Litre',
    'Meter',
    'Packet',
    'Piece',
    'Cartoon',
    'Dozen'
  ];
  final _openingStockController = TextEditingController(text: '00');
  final _dateController = TextEditingController();
  final _totalStockValueController = TextEditingController(text: '00');
  final _minimumOrderQuantity = TextEditingController(text: '00');
  bool _isExpanded = false;

  final inventoryItemViewModel = Get.find<InventoryItemViewModel>();
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        widget.isEditMode
            ? _dateTime = DateFormat('dd-MM-yyyy hh:mm a').format(picked)
            : _dateController.text =
                DateFormat('dd-MM-yyyy  hh:mm a').format(picked);
      });
    }
  }

  Future<void> _scanBarcode() async {
    try {
      var result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      setState(() {
        _barcodeController.text = result;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  Future _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  void _alertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        _getImageFromGallery();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose existing photo')),
                  TextButton.icon(
                      onPressed: () {
                        _getImageFromCamera();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Take photo'))
                ],
              ),
            ),
          );
        });
  }

  void _saveData() async {
    final name = _itemNameController.text.isEmpty
        ? 'something'
        : _itemNameController.text;
    final imagePath = _image == null ? '' : _image!.path.toString();
    final barcode =
        _barcodeController.text.isEmpty ? '' : _barcodeController.text;
    final purchasePrice = _purchasePriceController.text.isEmpty
        ? 0.0
        : double.parse(_purchasePriceController.text);
    final salesPrice = _salesPriceController.text.isEmpty
        ? 0.0
        : double.parse(_salesPriceController.text);
    final unit = _selectedOption.toString();
    final openingStock = double.parse(_openingStockController.text);
    final dateTime = _dateController.text;
    final pricePerUnit = double.parse(_pricePerUnitController.text);
    final totalValue = double.parse(_totalStockValueController.text);
    final minOrderQty = double.parse(_minimumOrderQuantity.text);
    inventoryItemViewModel.addItem(
        name,
        imagePath,
        barcode,
        purchasePrice,
        salesPrice,
        unit,
        openingStock,
        dateTime,
        pricePerUnit,
        totalValue,
        minOrderQty);
    Fluttertoast.showToast(msg: 'Data inserted successfully!');
    Get.toNamed('/products_List');
  }

  void _editData() async {
    final name = _name;
    final imagePath = _imagePath;
    final barcode = _barcode;
    final purchasePrice = _purchasePrice;
    final salesPrice = _salesPrice;
    final unit = _unit;
    final openingStock = _openingStock;
    final dateTime = _dateTime;
    final pricePerUnit = _pricePerUnit;
    final totalValue = _totalValue;
    final minOrderQty = _minOrderQty;
    final newData = InventoryItem(
        id: int.parse(widget.leadingValue),
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
        minOrderQty: minOrderQty);
    await inventoryItemViewModel.updateItem(newData);
    setState(() {
      Fluttertoast.showToast(msg: 'Data updated successfully!');
      Get.to(() => const ProductsList());
    });
    // Fluttertoast.showToast(msg: 'Data updated successfully!');
    // Get.to(() => const ProductsList());
  }

  String _name = '', _imagePath = '', _barcode = '', _unit = '', _dateTime = '';
  double _purchasePrice = 0.0,
      _salesPrice = 0.0,
      _openingStock = 0.0,
      _pricePerUnit = 0.0,
      _totalValue = 0.0,
      _minOrderQty = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _name = widget.item!.name;
      _imagePath = widget.item!.imagePath;
      _barcode = widget.item!.barcode;
      _purchasePrice = widget.item!.purchasePrice;
      _salesPrice = widget.item!.salesPrice;
      _unit = widget.item!.unit;
      _openingStock = widget.item!.openingStock;
      _dateTime = widget.item!.dateTime;
      _pricePerUnit = widget.item!.pricePerUnit;
      _totalValue = widget.item!.totalValue;
      _minOrderQty = widget.item!.minOrderQty;
    }
    _dateController.text =
        DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.isEditMode
            ? 'Edit An Inventory Item'
            : 'Add An Inventory Item'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.calculate)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 5),
                        child: widget.isEditMode
                            ? TextFormField(
                                initialValue: widget.item!.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an item name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _name = value!;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Item Name'),
                                keyboardType: TextInputType.name,
                              )
                            : CustomTextField(
                                controller: _itemNameController,
                                label: 'Item Name',
                                keyboard: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isBlank) {
                                    return 'Please enter an item name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _itemNameController.text = value;
                                },
                              ),
                      ),
                    ),
                    InkWell(
                        onTap: _alertDialog,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 5, right: 5),
                          child: Container(
                              child: _image == null
                                  ? const Icon(
                                      Icons.image_outlined,
                                      size: 50,
                                    )
                                  : Image.file(
                                      _image!,
                                      width: 80,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    )),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(children: [
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 5),
                    child: widget.isEditMode
                        ? TextFormField(
                            initialValue: widget.item!.barcode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please scan barcode or QR code';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _barcode = value!;
                            },
                            decoration: const InputDecoration(
                                label: Text('Barcode or QR code')),
                            keyboardType: TextInputType.number,
                          )
                        : CustomTextField(
                            controller: _barcodeController,
                            label: 'Bar Code/QR Code',
                            validator: (value) {
                              if (value == null || value.isBlank) {
                                return 'Please scan barcode or QR code';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _barcodeController.text = newValue;
                            },
                          ),
                  )),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 5, right: 10),
                    child: IconButton(
                        onPressed: _scanBarcode,
                        icon: const Icon(
                          Icons.qr_code_2_outlined,
                          size: 50,
                        )),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 5, bottom: 10),
                        child: widget.isEditMode
                            ? TextFormField(
                                initialValue:
                                    widget.item!.purchasePrice.toString(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter purchase price';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _purchasePrice = double.parse(value!);
                                },
                              )
                            : CustomTextField(
                                controller: _purchasePriceController,
                                label: 'Purchase Price',
                                validator: (value) {
                                  if (value == null || value.isBlank) {
                                    return 'Please enter purchase price';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _purchasePriceController.text = newValue;
                                },
                              ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: widget.isEditMode
                            ? TextFormField(
                                initialValue:
                                    widget.item!.salesPrice.toString(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter sales price';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _salesPrice = double.parse(value!);
                                },
                              )
                            : CustomTextField(
                                controller: _salesPriceController,
                                label: 'Sales Price',
                                validator: (value) {
                                  if (value == null || value.isBlank) {
                                    return 'Please enter sales price';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _salesPriceController.text = newValue;
                                },
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: ExpansionTile(
                  title: const Text(
                    '+ ADD STOCK DETAILS',
                    style: TextStyle(color: Colors.red),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit of measure',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomDropDownButton(
                              hintText: widget.isEditMode
                                  ? widget.item!.unit.toString()
                                  : _selectedOption,
                              items: _options
                                  .map((option) => DropdownMenuItem(
                                      value: option, child: Text(option)))
                                  .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedOption = newValue!;
                                });
                              }),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: widget.isEditMode
                                ? TextFormField(
                                    initialValue:
                                        widget.item!.openingStock.toString(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter stock value';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _openingStock = double.parse(value!);
                                    },
                                  )
                                : CustomTextField(
                                    controller: _openingStockController,
                                    label: 'Opening Stock',
                                    validator: (value) {
                                      if (value == null || value.isBlank) {
                                        return 'Please enter stock value';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _openingStockController.text = newValue;
                                    },
                                  ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: widget.isEditMode
                                    ? TextFormField(
                                        initialValue: widget.item!.dateTime,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select date';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _dateTime = value!;
                                        },
                                      )
                                    : TextFormField(
                                        // initialValue: widget.isEditMode
                                        //     ? widget.item!.dateTime
                                        //     : DateFormat('dd-MM-yyyy hh:mm a')
                                        // .format(DateTime.now()),
                                        controller: _dateController,
                                        decoration: const InputDecoration(
                                            labelText: 'AS ON DATE'),
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        onSaved: (newValue) {
                                          _dateController.text = newValue!;
                                        },
                                      )))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: widget.isEditMode
                              ? TextFormField(
                                  initialValue:
                                      widget.item!.pricePerUnit.toString(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter price per $_selectedOption';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _pricePerUnit = double.parse(value!);
                                  },
                                )
                              : CustomTextField(
                                  controller: _pricePerUnitController,
                                  label: 'Price/$_selectedOption',
                                  validator: (value) {
                                    if (value == null || value.isBlank) {
                                      return 'Please enter price per $_selectedOption';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _pricePerUnitController.text = newValue;
                                  },
                                ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: widget.isEditMode
                              ? TextFormField(
                                  initialValue:
                                      widget.item!.totalValue.toString(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter total stock value';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _totalValue = double.parse(value!);
                                  },
                                )
                              : TextFormField(
                                  // initialValue: widget.isEditMode
                                  //     ? widget.item!.totalValue.toString()
                                  //     : '$_pricePerUnit * $_openingStockController',
                                  controller: _totalStockValueController,
                                  decoration: const InputDecoration(
                                      labelText: 'Total Stock Value'),
                                  keyboardType: TextInputType.number,
                                ),
                        ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: widget.isEditMode
                          ? TextFormField(
                              initialValue: widget.item!.minOrderQty.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter minimum order quantity';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _minOrderQty = double.parse(value!);
                              },
                            )
                          : CustomTextField(
                              // initialValue: widget.isEditMode
                              //     ? widget.item!.minOrderQty
                              //     : _minimumOrderQuantity.text.toString(),
                              controller: _minimumOrderQuantity,
                              label: 'Minimum Order Quantity',
                              validator: (value) {
                                if (value == null || value.isBlank) {
                                  return 'Enter minimum order quantity';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _minimumOrderQuantity.text = newValue;
                              },
                            ),
                    )
                  ],
                  onExpansionChanged: (bool isExpanded) {
                    _toggleExpansion();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: 'Save & New',
                onPress: () {},
                color: Colors.white,
                textColor: Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomButton(
                title: widget.isEditMode ? 'Edit' : 'Save',
                onPress: () {
                  if (widget.isEditMode) {
                    _editData();
                  } else {
                    _saveData();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
