import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdvp/components/backend/admin/create_admin.dart';
import 'package:tdvp/components/backend/services/admin_service.dart';
import 'package:tdvp/components/frontend/customer/service/customer_service.dart';
import 'package:tdvp/components/frontend/guest/authentication/authentication.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/splashpage.dart';
import 'package:tdvp/utility/style.dart';

Map<String, WidgetBuilder> map = {
  StyleProjects.routeAdmin: (context) => AdminService(),
  StyleProjects.routeCustomer: (context) => const CustomerService(),
  StyleProjects.routeSplash: (context) => const SplashPage(),
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
        firstState = StyleProjects.routeSplash;
        break;
    }
  }

  await Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

// String initialRoute = '/authen';

// Future<Null> main() async {
//   HttpOverrides.global = MyHttpOverride();

//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp().then((value) async {
//     await FirebaseAuth.instance.authStateChanges().listen((event) {
//       if (event != null) {
//         initialRoute = '/splash';
//       }
//       runApp(MyApp());
//     });
//   });
// }

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
