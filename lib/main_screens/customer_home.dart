import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customers_app_google_play/main_screens/profile.dart';
import 'package:customers_app_google_play/main_screens/stores.dart';
import 'package:customers_app_google_play/main_screens/visit_store.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/constants2.dart';
import '../services/notification.dart';
import 'cart.dart';
import 'category.dart';
import 'home.dart';

class ScreenIndexProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get currentIndex => _selectedIndex;

  void updateScreenIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen>
    with SingleTickerProviderStateMixin {
  /* final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    const CartScreen(),
    const ProfileScreen(
        */ /*documentId: FirebaseAuth.instance.currentUser!.uid,*/ /*
        ),
  ];
*/
  displayForegroundNotifications() {
    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationsServices.displayNotification(message);
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'followers') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisitStore(
            suppId: message.data['sid'],
          ),
        ),
      );
    }
  }

  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    FirebaseMessaging.instance.getToken().then(
          (value) => print('token : $value'),
        );
    context.read<Cart>().loadCartItemsProvider();
    displayForegroundNotifications();
    setupInteractedMessage();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenIndexProvider>(
        builder: (context, screenIndexProvider, child) {
      return Scaffold(
        backgroundColor: scaffoldColor,
        body: PageView(
          controller: pageController,
          padEnds: true,
          onPageChanged: (value) =>
              screenIndexProvider.updateScreenIndex(value),
          children: const [
            HomeScreen(),
            CategoryScreen(),
            StoresScreen(),
            CartScreen(),
            ProfileScreen(
                /*documentId: FirebaseAuth.instance.currentUser!.uid,*/
                ),
            /*IndexedStack(
              index: screenIndexProvider.currentIndex,
              //sizing: StackFit.expand,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: const [
                HomeScreen(),
                CategoryScreen(),
                StoresScreen(),
                CartScreen(),
                ProfileScreen(
                    */ /*documentId: FirebaseAuth.instance.currentUser!.uid,*/ /*
                    ),
              ],
            ),*/
          ],
        ),
        /*_tabs[currentScreenIndex],*/
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          mouseCursor: MouseCursor.defer,
          selectedItemColor: Colors.amber[300],
          unselectedItemColor: Colors.white30,
          backgroundColor: scaffoldColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Dosis',
            color: textColor,
            letterSpacing: 1.5.sp,
          ),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Dosis',
            color: scaffoldColor,
            letterSpacing: 1.4.sp,
          ),
          currentIndex: screenIndexProvider.currentIndex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(PixelArtIcons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shape_line_outlined),
              label: 'Category',
            ),
            const BottomNavigationBarItem(
              icon: Icon(PixelArtIcons.shopping_bag),
              label: 'Stores',
            ),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: badges.Badge(
                showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
                badgeContent: Text(
                  context.watch<Cart>().getItems.length.toString(),
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Icon(
                  PixelArtIcons.cart,
                ),
              ),
            ),
            const BottomNavigationBarItem(
              icon: Icon(FluentIcons.person_accounts_24_regular),
              label: 'Profile',
            ),
          ],
          onTap: (value) {
            screenIndexProvider.updateScreenIndex(value);
            setState(() {
              pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 100),
                curve: Curves.fastEaseInToSlowEaseOut,
              );
            });
          },
        ),
      );
    });
  }
}
