import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../screens/product_screen.dart';

class CategoryHomeBoxes extends StatelessWidget {
  const CategoryHomeBoxes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            categories.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProductScreen(
                                  category: categories[index].title!)));
                    },
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("${categories[index].image}"),fit: BoxFit.cover),
                          // boxShadow: [
                          //   BoxShadow(
                          //     blurRadius: 5,
                          //     spreadRadius: 3,
                          //     color: Colors.red.withOpacity(0.4),
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                          // color: Colors
                          //     .primaries[Random().nextInt(categories.length)],
                        ),
                        child: const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    categories[index].title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
