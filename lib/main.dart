import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdvp/components/backend/admin/create_admin.dart';
import 'package:tdvp/components/backend/services/services.dart';
import 'package:tdvp/components/frontend/customer/service/services.dart';
import 'package:tdvp/components/frontend/guest/home/homepage.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/splashpage.dart';
import 'package:tdvp/utility/style.dart';

// var getPages = <GetPage<dynamic>>[
//   GetPage(
//     name: '/splash',
//     page: () => SplashPage(),
//   ),
//   GetPage(
//     name: '/customer',
//     page: () => CustomerService(),
//   ),
//   GetPage(
//     name: '/admin',
//     page: () => AdminService(),
//   ),
// ];
// String firstPage = '/splash';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
// HttpOverrides.global = MyHttpOverride();
//   await Firebase.initializeApp().then((value) async {
//     print('## initial OK #################');
//     FirebaseAuth.instance.authStateChanges().listen((event) async {
//       if (event != null) {
//         print('## event ไม่เท่ากัน null');

//         String uid = event.uid;
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(uid)
//             .get()
//             .then((value) {
//           print('## value ----> ${value.data()}');

//           UserModel userModel = UserModel.fromMap(value.data()!);

//           print('## level ---> ${userModel.level}');

//           firstPage = '/${userModel.level}';
//           runApp(MyApp());
//         });
//       } else {
//         runApp(MyApp());
//       }
//     });
//   }); 
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverride();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

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
      // home: const SplashPage(),

      home: // AddAdminPage(),
          const HomePage(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primaryColor: StyleProjects().titlebar2,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           scaffoldBackgroundColor: Colors.white),
//       getPages: getPages,
//       initialRoute: firstPage,
//     );
//   }
// }

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
