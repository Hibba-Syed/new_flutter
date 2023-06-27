import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/models/product_model.dart';
import 'package:new_flutter/screens/product_detail_screen.dart';

import '../widget/header.dart';

class ProductScreen extends StatefulWidget {
  // const ProductScreen({Key? key}) : super(key: key);
  String? category;
  ProductScreen({this.category});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductsModel> allProducts = [];
 var searchC = TextEditingController();

  getDate() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      if (widget.category == null) {
        snapshot!.docs.forEach((e) {
          if (e.exists) {
            setState(() {
              allProducts.add(
                ProductsModel(
                  id: e["id"],
                  productName: e["productName"],
                  imageUrls: e["imageUrls"],
                ),
              );
            });
          }
        });
      } else {
        snapshot!.docs
            .where((element) => element["category"] == widget.category)
            .forEach((e) {
          if (e.exists) {
            setState(() {
              allProducts.add(
                ProductsModel(
                  id: e["id"],
                  productName: e["productName"],
                  imageUrls: e["imageUrls"],
                ),
              );
            });
          }
        });
      }
    });
    // print(allProducts[0].discountPrice);
  }

  List<ProductsModel> totalItems = [];

  @override
  void initState() {
    getDate();
    Future.delayed(const Duration(seconds: 1), () {
      totalItems.addAll(allProducts);
    });

    super.initState();
  }

  filterData(String query) {
    List<ProductsModel> dummySearch = [];
    dummySearch.addAll(allProducts);
    if (query.isNotEmpty) {
      List<ProductsModel> dummyData = [];
      dummySearch.forEach((element) {
        if (element.productName!.toLowerCase().contains(query.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        allProducts.clear();
        allProducts.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        allProducts.clear();

        allProducts.addAll(totalItems);
      });
      // return;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Header(
            title: widget.category ?? "ALL PRODUCTS",

          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: searchC,
              onChanged: (v) {
                filterData(searchC.text);
              },
              decoration:  InputDecoration(
                hintText: "search your favourite pro...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: allProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                              id: allProducts[index].id,
                            )));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Image.network(
                              allProducts[index].imageUrls!.last,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                              child: Text(
                                allProducts[index].productName!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(overflow: TextOverflow.ellipsis),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
