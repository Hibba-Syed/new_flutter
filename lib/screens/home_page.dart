import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/screens/product_detail_screen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../models/product_model.dart';
import '../widget/category_home_boxex.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ProductsModel> allProducts = [];

  getDate() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs.forEach((e) {
        if (e.exists) {
          setState(() {
            allProducts.add(
              ProductsModel(
                brand: e["brand"],
                category: e["category"],
                id: e['id'],
                productName: e["productName"],
                detail: e["detail"],
                price: e["price"],
                discountPrice: e["discountPrice"],
                serialCode: e["serialCode"],
                imageUrls: e["imageUrls"],
                isSale: e["isOnSale"],
                isPopular: e["isPopular"],
                isFavourite: e["isFavourite"],
              ),
            );
          });
        }
      });
    });
    print(allProducts[0].discountPrice);
  }
  @override
  void initState() {
    getDate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Side"),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 110,
              child: Column(
                children: [
                  CategoryHomeBoxes(),
                ],
              ),
            ),
            SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "POPULAR ITEMS",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    allProducts.isEmpty
                        ? const CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: 72,
                      selectedColor: Colors.red,
                      unselectedColor: Colors.grey,
                      padding: 0,
                      width: 100,
                      child: Icon(
                        Icons.tag_faces,
                        color: Colors.red,
                        size: 30,
                      ),
                    )
                        : PopularItems(allProducts: allProducts),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.greenAccent),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "HOT \n SALES",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize:20)
                                  ),
                                ),
                              ),
                            ),
                          ),
                         const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "NEW \n ARRIVALS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize:20)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "TOP BRANDS",
                      style: TextStyle(
                        fontSize: 25,

                      ),
                    ),
                    Brands(allProducts: allProducts),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
class PopularItems extends StatelessWidget {
  const PopularItems({
    Key? key,
    required this.allProducts,
  }) : super(key: key);

  final List<ProductsModel> allProducts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allProducts
            .where((element) => element.isPopular == true)
            .map((e) => Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>   ProductDetailScreen(
                            id: e.id,
                          )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Image.network(
                        e.imageUrls![0],
                        fit: BoxFit.fill,
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Text(e.productName!)
              ),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }
}
class Brands extends StatelessWidget {
  const Brands({
    Key? key,
    required this.allProducts,
  }) : super(key: key);

  final List<ProductsModel> allProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      constraints: const BoxConstraints(
        minWidth: 50,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allProducts
            .map((e) => Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 90,
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.primaries[Random().nextInt(15)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        e.brand!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}

