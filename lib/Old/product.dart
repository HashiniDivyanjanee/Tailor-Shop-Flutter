import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class product extends StatefulWidget {
  const product({super.key});

  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {
  List<String> categoryNames = [];
  String selectedCategory = '';
  String selectedRange = 'Women';
  TextEditingController product = TextEditingController();
  TextEditingController cost_price = TextEditingController();
  TextEditingController sale_price = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController category = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  File? _imageFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchCategory() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/Tailer/category_name.php'));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        categoryNames = List<String>.from(json.decode(response.body));
        print("Categories fetched: $categoryNames");
      });
    } else {
      throw Exception('Failed to load category names');
    }
  }

  Future<void> insertrecord() async {
    if (product.text != "" || sale_price.text != "" || qty.text != "") {
      try {
        String uri = "http://127.0.0.1/Tailer/product.php";
        var request = http.MultipartRequest('POST', Uri.parse(uri))
          ..fields['product'] = product.text
          ..fields['cost_price'] = cost_price.text
          ..fields['sale_price'] = sale_price.text
          ..fields['discount'] = discount.text
          ..fields['qty'] = qty.text
          ..fields['color'] = color.text
          ..fields['category'] = selectedCategory
          ..fields['range'] = selectedRange;
        // Check if an image file is selected
        if (_imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image', // Must match the name expected by your PHP script
            _imageFile!.path,
          ));
        }
        var res = await request.send();
        var responseString = await res.stream.bytesToString();
        print("Raw response: $responseString");

        // Then decode the response
        var response = jsonDecode(responseString);
        if (response["success"] == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product Saved Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product Saved Failed!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter all Details'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(3, 191, 203, 1),
                Color.fromRGBO(3, 191, 203, 1),
              ],
            ),
          ),
        ),
        title: Text('PRODUCT'),
        actions: [
         
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile view
            return buildMobileView();
          } else {
            // Desktop view
            return buildDesktopView();
          }
        },
      ),
    );
  }

  Widget buildMobileView() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mobile Supplier View',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  // *** Start of Desktop View ***
  Widget buildDesktopView() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 1700,
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 65, left: 30, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BASIC INFORMATION',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 25),
                                TextFormField(
                                  controller: product,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Product Name',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 15),
                                DropdownButtonFormField(
                                  value: categoryNames.isNotEmpty
                                      ? (selectedCategory.isNotEmpty
                                          ? selectedCategory
                                          : categoryNames.first)
                                      : null, // Set value to null if the list is empty
                                  items: categoryNames
                                      .map((category) => DropdownMenuItem(
                                            child: Text(category),
                                            value: category,
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  value: selectedRange,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRange = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Payment Method',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                  ),
                                  items: [
                                    'Women',
                                    'Men',
                                    'Girl',
                                    'Boy',
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: color,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Color',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 65, left: 30, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PRICE & QUANTITY',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  controller: cost_price,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Cost Price',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: sale_price,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Sale Price',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: qty,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Quantity',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: discount,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Discount',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 65, left: 30, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'IMAGE',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: pickImage,
                                      child: Text('Select Image'),
                                    ),
                                    SizedBox(height: 20),
                                    if (_imageFile != null)
                                      Image.file(_imageFile!),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 110, right: 20, top: 50, bottom: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(3, 191, 203, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            insertrecord();
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(171, 122, 122, 122),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            product.clear();
                            color.clear();
                            cost_price.clear();
                            sale_price.clear();
                            qty.clear();
                            discount.clear();
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmpSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const EmpSearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 1300, right: 30, bottom: 10),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: TextField(
          style: TextStyle(
            backgroundColor: Color.fromARGB(255, 139, 172, 214),
          ),
          onChanged: onSearch,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromRGBO(3, 191, 203, 1),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
          ),
        ),
      ),
    );
  }
}
