import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/assessment/result_assessment.dart';
import 'package:tdvp/components/frontend/customer/buy/lists_category.dart';
import 'package:tdvp/components/frontend/customer/dashboard/dashboardpage.dart';
import 'package:tdvp/components/frontend/customer/ordershistory/history_orders.dart';
import 'package:tdvp/components/frontend/customer/profile/customer_dataprofile.dart';
import 'package:tdvp/components/frontend/guest/assessment/assessment.dart';
import 'package:tdvp/components/frontend/guest/authentication/authentication.dart';
import 'package:tdvp/controller/app_dialog.dart';
//import 'package:tdvp/components/frontend/customer/processbuy/lists_category.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/style.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerServiceState createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  UserModel? userModel;

  Widget currentWidget = const DashboardPage(
    uid: '',
  );

  String? fname;
  String? email;
  var user = FirebaseAuth.instance.currentUser;
  bool load = true;

  @override
  void initState() {
    super.initState();
    findNameAnEmail();
  }

  // Future<Null> findToken(String uid) async {
  //   await Firebase.initializeApp().then((value) async {
  //     FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //     await firebaseMessaging.getToken().then((value) async {
  //       print('### uid ที่ login อยู่ ==>> $uid');
  //       print('### token ==> $value');

  //       Map<String, dynamic> data = {};
  //       data['token'] = value;

  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(uid)
  //           .update(data)
  //           .then((value) => print('Update Token Success'));
  //     });
  //   });
  // }

  Future<Null> findToken(String uid) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.getToken().then((value) async {
      print('### uid ที่ login อยู่ ==>> $uid');
      print('##3feb token ==> $value');

      Map<String, dynamic> data = Map();
      //Map<String, dynamic> data = {};
      data['token'] = value;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(data)
          .then((value) => print('Update Token Success'));
    });

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission();
    print('##3feb setting ===> ${notificationSettings.authorizationStatus}');

    // open App
    FirebaseMessaging.onMessage.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      print('##3feb onMessage เปิดแอพอยู่ ---> $title, $body');
      AppDialog(context: context).normalDialog(title: title!, message: body!);
    });

    // Close App
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;

      print('##3feb onMessage ปิดแอพอยู่ ---> $title, $body');
      AppDialog(context: context).normalDialog(title: title!, message: body!);
    });
  }

  Future<Null> findNameAnEmail() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        String uid = event!.uid;
        findToken(uid);
        setState(() {
          fname = event.displayName;
          email = event.email;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
        // ignore: prefer_const_literals_to_create_immutables
        actions: <Widget>[
          // const ConfigLogout(),
          IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthenticationPage(),
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildUserAccountsDrawerHeader(),
                  blockProfile(),
                  blockOrders(),
                  blockHistory(),
                  blockAssessment(),
                  //showSavePrice(),
                ],
              ),
            ),
            blocklogout(),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile blockProfile() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(Icons.assignment_ind, color: Colors.black),
        onPressed: () {},
      ),
      title: Text(
        'ข้อมูลส่วนบุคคล',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const CustomerReaderProfilePage(),
        //   ),
        // );
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CustomerReaderProfilePage(),
        ));
      },
    );
  }

  ListTile blockAssessment() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(Icons.money_off_sharp, color: Colors.black),
        onPressed: () async {},
      ),
      title: Text(
        'รายการประเมินก่อนการพิมพ์',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const AssessmentPage(),
        //   ),
        // );
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => const AssessmentPage(),
        // ));
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AssessmentPage(),
        ));
      },
    );
  }

  ListTile showSavePrice() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(Icons.save, color: Colors.black),
        onPressed: () {},
      ),
      title: Text(
        'แสดง Price ที่ Save',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ResultAssessmentPage(),
        ));
      },
    );
  }

  ListTile blockOrders() {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
        onPressed: () {},
      ),
      title: Text(
        'สั่งซื้อ/สั่งพิมพ์แบบพิมพ์',
        style: StyleProjects().topicstyle9,
        // style: TextStyle(
      ),
      onTap: () {
        // Get.back();
        // Get.to(
        //   const ListCategoryPage(),
        // );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ListCategoryPage(),
        //   ),
        // );

        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ListCategoryPage(),
        ));
      },
    );
  }

  ListTile blockHistory() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(Icons.description_outlined, color: Colors.black),
        onPressed: () {},
      ),
      title: Text(
        'ประวัติการสั่งซื้อ/สั่งพิมพ์',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        // Get.back();
        // Get.to(const HistoryOrdersPages());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const HistoryOrdersPages(),
        //   ),
        // );
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HistoryOrdersPages(),
        ));
      },
    );
  }

  Column blocklogout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: ListTile(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthenticationPage(),
                ),
              );
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 253, 253, 253),
            ),
            title: const Text(
              'ออกจากระบบ',
              style: TextStyle(
                fontFamily: 'THSarabunNew',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('assets/images/tree.jpeg'), fit: BoxFit.cover),
      ),
      // accountName:
      //     StyleProjects().topicaccount2(fname == null ? 'fname' : fname!),
      accountName: Text(""),
      accountEmail: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "อีเมล",
                  style: StyleProjects().topicstyle8,
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  email == null ? 'email' : email!,
                  style: StyleProjects().topicstyle8,
                ),
              ),
            ],
          ),

          // Text(
          //   email == null ? 'email' : email!,
          //   style: StyleProjects().topicstyle8,
          // ),

          // ConfigText(
          //   lable: "อีเมล",
          //   textStyle: StyleProjects().topicstyle8,
          // ),
          // StyleProjects().boxwidth2,
          // ConfigText(
          //   lable: email == null ? 'email' : email!,
          //   textStyle: StyleProjects().topicstyle8,
          // ),
          //  StyleProjects().topicaccount2(email == null ? 'email' : email!),
        ],
      ),
      currentAccountPicture: Image.asset(
        'assets/images/iconpro.png',
      ),
    );
  }
}
