import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rani_gold_admin/service/local_push_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import './screens/home_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/gold_rate/gold_rate.dart';
import './screens/slider/slider_view.dart';
import './screens/customer/customer_screen.dart';
import './screens/customer/create_customer_screen.dart';
import './screens/customer/update_customer.dart';
import './screens/customer/customer_view.dart';
import './screens/customer/pay_amount.dart';
import './screens/customer/purchase_amount.dart';
import './screens/staff/create_staff_screen.dart';
import './screens/staff/staff_list_screen.dart';
import './screens/auth/password_change_screen.dart';

import './providers/slider.dart' as slid;
import './providers/goldrate.dart';
import './providers/user.dart';
import './providers/transaction.dart' as trans;
import './providers/staff.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _checkValue;
  

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _checkValue = prefs.containsKey('staff');
    });

    super.didChangeDependencies();
  }

  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Staff(),
        ),
        ChangeNotifierProvider(
          create: (_) => User(),
        ),
        ChangeNotifierProvider(
          create: (_) => Goldrate(),
        ),
        ChangeNotifierProvider(
          create: (_) => trans.Transaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => slid.Slider(),
        ),
      ],
      child: MaterialApp(
          title: 'Rani Jewellery',
          theme: ThemeData(
            primarySwatch: buildMaterialColor(Color(0xFF612e3e)),
            accentColor: Colors.amber,
            fontFamily: 'Lato',
          ),
          home: _checkValue == true ? HomeScreen() : LoginScreen(),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            CustomerScreen.routeName: (ctx) => CustomerScreen(),
            CreateCustomerScreen.routeName: (ctx) => CreateCustomerScreen(),
            UpdateCustomerScreen.routeName: (ctx) => UpdateCustomerScreen(),
            CustomerViewScreen.routeName: (ctx) => CustomerViewScreen(),
            PayAmountScreen.routeName: (ctx) => PayAmountScreen(),
            PurchaseAmountScreen.routeName: (ctx) => PurchaseAmountScreen(),

            GoldRateScreen.routeName: (ctx) => GoldRateScreen(),
            ViewSlidersScreen.routeName: (ctx) => ViewSlidersScreen(),
            StaffListScreen.routeName: (ctx) => StaffListScreen(),
            CreateStaffScreen.routeName: (ctx) => CreateStaffScreen(),
            PasswordChangeScreen.routeName: (ctx) => PasswordChangeScreen()
            // UploadSlideScreen.routeName: (ctx) => UploadSlideScreen(),
          }),
    );
  }
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
