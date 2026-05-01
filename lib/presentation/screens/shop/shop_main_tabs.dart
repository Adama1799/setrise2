// lib/presentation/screens/shop/shop_main_tabs.dart
import 'package:flutter/cupertino.dart';
import 'shop_home_screen.dart';
import 'search/shop_search_screen.dart';
import 'auction/auction_screen.dart';
import 'cart/cart_screen.dart';
import 'account/orders_screen.dart';

class ShopMainTabs extends StatefulWidget {
  const ShopMainTabs({super.key});
  @override
  State<ShopMainTabs> createState() => _ShopMainTabsState();
}

class _ShopMainTabsState extends State<ShopMainTabs> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const ShopHomeScreen(),
    const ShopSearchScreen(),
    const AuctionScreen(),
    const CartScreen(),
    const OrdersScreen(), // يمكن استبدالها بـ AccountScreen مخصصة
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.systemOrange,
        inactiveColor: CupertinoColors.systemGrey,
        backgroundColor: CupertinoColors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.hammer), label: 'Auctions'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: 'Account'),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(builder: (context) => _pages[index]);
      },
    );
  }
}
