import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdvp/components/backend/admin/create_admin.dart';
import 'package:tdvp/components/backend/services/admin_service.dart';
import 'package:tdvp/components/frontend/customer/service/customer_service.dart';
import 'package:tdvp/components/frontend/guest/authentication/authentication.dart';
import 'package:tdvp/splashpage.dart';
import 'package:tdvp/utility/style.dart';

Map<String, WidgetBuilder> map = {
  StyleProjects.routeAuthen: (context) => const AuthenticationPage(),
  StyleProjects.routeAdmin: (context) => AdminService(),
  StyleProjects.routeCustomer: (context) => const CustomerService(),
};

String? firstState;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = preferences.getStringList('data');
  print('result main = $result');

  if (result != null) {
    var datas = <String>[];
    datas.addAll(result);

    switch (datas[1]) {
      case 'admin':
        firstState = StyleProjects.routeAdmin;
        break;
      case 'customer':
        firstState = StyleProjects.routeCustomer;
        break;
      default:
        firstState = StyleProjects.routeAuthen;
        break;
    }
  }

  await Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

//
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tdvp',
      theme: ThemeData(
          primaryColor: StyleProjects().primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white),
      home: const SplashPage(),

      // home: AddAdminPage(),
      //     const HomePage(),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
