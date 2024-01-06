import 'package:homelyf_services/constants/global_variables.dart';
import 'package:homelyf_services/features/account/screens/account_screen.dart';
import 'package:homelyf_services/features/cart/screens/cart_screen.dart';
import 'package:homelyf_services/features/home/screens/home_screen.dart';
import 'package:homelyf_services/providers/user_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          const BottomNavigationBarItem(
            // icon: Container(
            //   width: bottomBarWidth,
            // decoration: BoxDecoration(
            //   border: Border(
            //     top: BorderSide(
            //       color: _page == 0
            //           ? GlobalVariables.selectedNavBarColor
            //           : GlobalVariables.backgroundColor,
            //       width: bottomBarBorderWidth,
            //     ),
            //   ),
            // ),
            icon: Icon(
              Icons.home_rounded,
            ),
            // ),
            label: 'Home',
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              // decoration: BoxDecoration(
              //   border: Border(
              //     top: BorderSide(
              //       color: _page == 1
              //           ? GlobalVariables.selectedNavBarColor
              //           : GlobalVariables.backgroundColor,
              //       width: bottomBarBorderWidth,
              //     ),
              //   ),
              // ),
              child: const Icon(
                Icons.person_sharp,
              ),
            ),
            label: 'Account',
          ),
          // CART
          BottomNavigationBarItem(
            icon: Container(
              // width: bottomBarWidth,
              // decoration: BoxDecoration(
              //   border: Border(
              //     top: BorderSide(
              //       color: _page == 2
              //           ? GlobalVariables.selectedNavBarColor
              //           : GlobalVariables.backgroundColor,
              //       width: bottomBarBorderWidth,
              //     ),
              //   ),
              // ),
              child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                  elevation: 0,
                ),
                badgeContent: Text(
                  userCartLen.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                position: badges.BadgePosition.custom(top: -10, end: -6),
                child: const Icon(
                  Icons.shopping_cart_rounded,
                ),
              ),
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
