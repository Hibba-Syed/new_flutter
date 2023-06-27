import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/screens/product_detail_screen.dart';
import 'package:new_flutter/screens/product_screen.dart';
import 'cart_screen.dart';
import 'favourite-screen.dart';
import 'home_page.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({ Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int length = 0;

  void cartItemsLength() {
    FirebaseFirestore.instance.collection('cart').get().then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          length = snap.docs.length;
        });
      } else {
        setState(() {
          length = 0;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    cartItemsLength();
    return WillPopScope(
      onWillPop: (){
        if(_selectedPage == 0){
          return Future.value(true);
        }else{
          setState(() {
            _selectedPage = 0;
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: _selectedPage != 1 ?  Colors.white : Colors.grey[50],
        bottomNavigationBar: bottomNavigationBar(),
        body: SafeArea(child: pages[_selectedPage],),
      ),
    );
  }
  int _selectedPage = 0;
  void _selectPage(int index){
    // if(index == 3){
    //   context.push(child: const SignIn());
    //   return;
    // }
    setState(() {
      _selectedPage = index;
    });
  }
  List<Widget> pages = [
    const HomeScreen() ,
   // const Saved(),
    // if(provider.notif.isNotEmpty)...[
    // NewsWidget(model: provider.news.first,),
    CartScreen(),
    const FavouriteScreen(),
     ProductScreen(),
  ];
  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: _selectPage,
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedPage,
      type: BottomNavigationBarType.fixed,
      items: [
        // bottomNavigationBarItem(_selectedPage == 0 ? Icons.home : Icons.home,),
        // bottomNavigationBarItem(_selectedPage == 1 ? Icons.shopping_cart : Icons.shopping_cart,),
        // bottomNavigationBarItem(_selectedPage == 2 ? Icons.favorite_outline_sharp : Icons.favorite_outline_sharp,),
        // bottomNavigationBarItem(_selectedPage == 3 ? Icons.person : Icons.person,),
        bottomNavigationBarItem(Icons.home, 0),
        bottomNavigationBarItem(Icons.shopping_cart, 1),
        bottomNavigationBarItem(Icons.favorite_outline_sharp, 2),
        bottomNavigationBarItem(Icons.shopping_bag_outlined, 3),
        bottomNavigationBarItem(Icons.person, 4),
      ],
    );
  }

  // BottomNavigationBarItem bottomNavigationBarItem(IconData icon) {
  //   return BottomNavigationBarItem(icon: Icon(icon), label: "",);
  // }
  BottomNavigationBarItem bottomNavigationBarItem(IconData icon, int index) {
    if (index == 1) {
      // Apply Stack only to the shopping cart icon
      return BottomNavigationBarItem(
        icon: Stack(
          children: [
            const Icon(Icons.add_shopping_cart),
            Positioned(
                bottom: 4,
                left: 7,
                child: length == 0
                    ? Container()
                    : Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 18,
                      color: Colors.green,
                    ),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$length",
                              style: const TextStyle(color: Colors.white,fontSize: 11),
                            )))
                  ],
                ))
          ],
        ),
        label: "",
      );
    } else {
      // For other icons, use the regular BottomNavigationBarItem without Stack
      return BottomNavigationBarItem(
        icon: Icon(icon),
        label: "",
      );
    }
  }



}