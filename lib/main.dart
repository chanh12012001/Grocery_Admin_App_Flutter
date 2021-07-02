import 'package:flutter/material.dart';
import 'package:grocery_admin_app_flutter/screens/admin_users.dart';
import 'package:grocery_admin_app_flutter/screens/category_screen.dart';
import 'package:grocery_admin_app_flutter/screens/delivery_boy_screen.dart';
import 'package:grocery_admin_app_flutter/screens/login_screen.dart';
import 'package:grocery_admin_app_flutter/screens/manage_banners.dart';
import 'package:grocery_admin_app_flutter/screens/notification_screen.dart';
import 'package:grocery_admin_app_flutter/screens/order_screen.dart';
import 'package:grocery_admin_app_flutter/screens/settings_screen.dart';
import 'package:grocery_admin_app_flutter/screens/splash_screen.dart';
import 'package:grocery_admin_app_flutter/screens/vendor_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App Admin Dash Board',
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        BannerScreen.id:(context)=>BannerScreen(),
        CategoryScreen.id:(context)=>CategoryScreen(),
        OrderScreen.id:(context)=>OrderScreen(),
        NotificationScreen.id:(context)=>NotificationScreen(),
        AdminUsers.id:(context)=>AdminUsers(),
        SettingScreen.id:(context)=>SettingScreen(),
        VendorScreen.id:(context)=>VendorScreen(),
        DeliveryBoyScreen.id:(context)=>DeliveryBoyScreen(),
      },
    );
  }
}


