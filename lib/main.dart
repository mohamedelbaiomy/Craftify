import 'package:customers_app_google_play/customer_screens/customer_orders.dart';
import 'package:customers_app_google_play/firebase_options.dart';
//import 'package:customers_app_google_play/providers/stripe_id.dart';
//import 'package:customers_app_google_play/providers/stripe_id.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:customers_app_google_play/main_screens/splash_screen.dart';
import 'package:customers_app_google_play/providers/cart_provider.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:customers_app_google_play/providers/sql_helper.dart';
import 'package:customers_app_google_play/providers/wish_provider.dart';
import 'package:customers_app_google_play/services/notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'auth/customer_login.dart';
import 'auth/customer_signup.dart';
import 'main_screens/customer_home.dart';
import 'minor_screens/thanks_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

//List<String> testDeviceIds = ['289C....E6'];

void main() async {
  /*WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);*/
  /*WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Timer(const Duration(seconds: 2), () => FlutterNativeSplash.remove());*/
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  /*RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);*/
  /*Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();*/
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  NotificationsServices.createNotificationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SQLHelper.getDatabase;

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
                size: 100,
              ),
              SizedBox(height: 20.h),
              Text(
                kReleaseMode
                    ? 'Oops... something went wrong reopen the app'
                    : errorDetails.exception.toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Dosis',
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Wish()),
        ChangeNotifierProvider(create: (_) => IdProvider()),
        ChangeNotifierProvider(create: (ctx) => ScreenIndexProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*final cfg = AppcastConfiguration(
        url: 'https://play.google.com/store/apps/details?id=customers_app_google_play.com.customers_app_google_play',
        supportedOS: ['android']);
    upgrader: Upgrader(
      dialogStyle: UpgradeDialogStyle.cupertino,
      canDismissDialog: false,
      showIgnore: false,
      appcastConfig: cfg,
      minAppVersion: '1.1.7',
      debugDisplayAlways: true,
      showReleaseNotes: true,
      showLater: false,
    ),*/
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: scaffoldColor,
        statusBarColor: Colors.transparent,
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => ScreenIndexProvider(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            //useInheritedMediaQuery: true,
            //color: scaffoldColor,
            home: const SplashScreen(),
            theme: ThemeData(
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                color: Colors.transparent,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                color: Colors.transparent,
              ),
            ),
            title: 'Craftify',
            routes: {
              '/thanks_screen': (context) => const ThanksScreen(),
              //'/welcome_screen': (context) => const WelcomeScreen(),
              //'/onboarding_screen': (context) => const OnboardingScreen(),
              '/customer_home': (context) => const CustomerHomeScreen(),
              '/customer_signup': (context) => const CustomerRegister(),
              '/customer_orders': (context) => const CustomerOrders(),
              '/customer_login': (context) => const CustomerLogin(),
            },
          );
        },
      ),
    );
  }
}
