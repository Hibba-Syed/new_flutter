import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'favourite-screen.dart';
import 'home_page.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({ Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBarItem(_selectedPage == 0 ? Icons.home : Icons.home,),
        bottomNavigationBarItem(_selectedPage == 1 ? Icons.shopping_cart : Icons.shopping_cart,),
        bottomNavigationBarItem(_selectedPage == 2 ? Icons.favorite_outline_sharp : Icons.favorite_outline_sharp,),
        bottomNavigationBarItem(_selectedPage == 3 ? Icons.person : Icons.person,),
      ],
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem(IconData icon) {
    return BottomNavigationBarItem(icon: Icon(icon), label: "",);
  }


}