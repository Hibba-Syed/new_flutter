import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/models/product_model.dart';
import '../models/cart_model.dart';
import '../widget/app_button.dart';
import '../widget/header.dart';


class ProductDetailScreen extends StatefulWidget {
  final String? id;
  const ProductDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<ProductsModel> allProducts = [];
  int count = 1;
  var newPrice = 0;
  bool isLoading = false;

  getDate() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
          snapshot!.docs
          .where((element) => element["id"] == widget.id)
          .forEach((e) {
        if (e.exists) {
          for (var item in e["imageUrls"]) {
            if (item.isNotEmpty) {
              setState(() {
                allProducts.add(
                  ProductsModel(
                      id: e["id"],
                      detail: e["detail"],
                      productName: e["productName"],
                      imageUrls: e["imageUrls"],
                      price: e['price'],
                      discountPrice: e['discountPrice']),
                );
              });
            }
          }
        }
        newPrice = allProducts.first.price!;
      });
    });
    // print(allProducts[0].discountPrice);
  }
  addToFavrourite() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('favourite');
        await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .add({"pid": allProducts.first.id});
  }
  removeToFavrourite(String id) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('favourite');
        await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(id)
        .delete();
  }
  @override
  void initState() {
    getDate();
    super.initState();
  }
  bool isfvrt = false;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return allProducts.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(49),
                child: Header(
                  title: "${allProducts.first.productName}",
                )),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    allProducts[0].imageUrls![selectedIndex],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...List.generate(
                          allProducts[0].imageUrls!.length,
                          (index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 110,
                                width: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Image.network(
                                  allProducts[0].imageUrls![index],
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 35,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text("${allProducts.first.price} PKR",
                                style: const TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('favourite')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('items')
                          .where('pid', isEqualTo: allProducts.first.id)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return const Text("");
                        }
                        return IconButton(
                            onPressed: () {
                              snapshot.data!.docs.isEmpty
                                  ? addToFavrourite()
                                  : removeToFavrourite(
                                      snapshot.data!.docs.first.id);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: snapshot.data!.docs.isEmpty
                                  ? Colors.black
                                  : Colors.red,
                            ));
                      }),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        allProducts.first.detail!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "NOTE :  Discount of ${allProducts.first.discountPrice} PKR will be applied when you order more then three items of this product"),
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (count > 1) {
                                count--;
                                if (count > 3) {
                                  newPrice =
                                      count * allProducts.first.discountPrice!;
                                } else {
                                  newPrice = count * allProducts.first.price!;
                                }
                              }
                            });
                          },
                          icon: const Icon(Icons.exposure_minus_1),
                        ),
                        Text(
                          "$count",
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              count++;
                              if (count > 3) {
                                newPrice =
                                    count * allProducts.first.discountPrice!;
                              } else {
                                newPrice = count * allProducts.first.price!;
                              }
                            });
                          },
                          icon: const Icon(Icons.exposure_plus_1),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text("$newPrice PKR",
                                      style:const TextStyle(color: Colors.white))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    isLoginButton: true,
                    isLoading: isLoading,
                    onPress: () {
                      setState(() {
                        isLoading = true;
                      });
                      CartModel.addtoCart(CartModel(
                              id: allProducts.first.id,
                              image: allProducts.first.imageUrls!.first,
                              name: allProducts.first.productName,
                              quantity: count,
                              price: newPrice))
                          .whenComplete(() {
                        setState(() {
                          isLoading = false;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Added to cart successfully")));
                        });
                      });
                    },
                    title: "Add to Cart",
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          );
  }
}
