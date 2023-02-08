import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdvp/components/frontend/customer/assessment/result_assessment.dart';
import 'package:tdvp/components/frontend/customer/dashboard/dashboardpage.dart';
import 'package:tdvp/components/frontend/customer/orders/history_orders.dart';
import 'package:tdvp/components/frontend/customer/profile/customer_dataprofile.dart';
import 'package:tdvp/components/frontend/guest/authentication/authentication.dart';
import 'package:tdvp/components/frontend/products/lists_category.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/states/display_price_save.dart';
import 'package:tdvp/utility/app_dialog.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/style.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerServiceState createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  UserModel? userModel;
  Widget currentWidget = DashboardPage();
  String? fname;
  String? email;

  @override
  void initState() {
    super.initState();
    findNameAnEmail();
    findUserLogin();
  }

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
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        String uid = event!.uid;
        findToken(uid);
        setState(() {
          //fname = event.displayName;
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
                // await FirebaseAuth.instance.signOut().then((value) {
                //   //Get.offAll(const AuthenticationPage());
                //   Navigator.pop(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const AuthenticationPage(),
                //     ),
                //   );
                // });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthenticationPage(),
                  ),
                );
              },

              // onPressed: () async {
              //   showDialog(
              //     context: context,
              //     builder: (BuildContext context) => AlertDialog(
              //       title: ConfigText(
              //         lable: 'Exit',
              //         textStyle: StyleProjects().alertstyle1,
              //       ),
              //       content: ConfigText(
              //         lable: 'คุณต้องการออกจากระบบ ?',
              //         textStyle: StyleProjects().alertstyle2,
              //       ),
              //       actions: [
              //         TextButton(
              //           onPressed: () async {
              //             await FirebaseAuth.instance.signOut().then((value) {
              //               Get.offAll(const AuthenticationPage());
              //             });
              //           },
              //           child: Text(
              //             'ใช่',
              //             style: StyleProjects().alertstyle2,
              //           ),
              //         ),
              //         TextButton(
              //           //onPressed: () => Navigator.pop(context),
              //           onPressed: () {
              //             Get.to(const CustomerService());
              //           },
              //           child: Text(
              //             'ไม่',
              //             style: StyleProjects().alertstyle2,
              //           ),
              //         ),
              //       ],
              //     ),
              //   );

              // },
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
                  showSavePrice(),
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
        onPressed: () async {
          // Get.back();
          // Get.to(const CustomerReaderProfilePage());
        },
      ),
      title: Text(
        'แก้ไขข้อมูลส่วนตัว',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        // Get.back();
        // Get.to(const CustomerReaderProfilePage());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomerReaderProfilePage(),
          ),
        );
      },
    );
  }

  ListTile showSavePrice() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(Icons.save, color: Colors.black),
        // onPressed: () async {
        //   Get.back();
        //   Get.to(const DisplayPriceSave());
        // },
        onPressed: () {},
      ),
      title: Text(
        'แสดง Price ที่ Save',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        // Get.back();
        // Get.to(const DisplayPriceSave());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultAssessmentPage(),
          ),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ListCategoryPage(),
          ),
        );
      },
    );
  }

  ListTile blockHistory() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(Icons.description_outlined, color: Colors.black),
        // onPressed: () async {
        //   // Get.back();
        //   // Get.to(const HistoryOrdersPages());
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const HistoryOrdersPages(),
        //     ),
        //   );
        // },
        onPressed: () {},
      ),
      title: Text(
        'ประวัติการสั่งซื้อ/สั่งพิมพ์',
        style: StyleProjects().topicstyle9,
      ),
      onTap: () {
        // Get.back();
        // Get.to(const HistoryOrdersPages());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HistoryOrdersPages(),
          ),
        );
      },
    );
  }

  /*  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pro901.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: userModel == null
          ? Image.asset('assets/images/avatar.png')
          : const CircleAvatar(
              radius: 30.0,

              //backgroundImage: NetworkImage(userModel.images),
              /*
              backgroundImage:
                    NetworkImage("${snapshot.data.hitsList[index].images}"),
                backgroundColor: Colors.transparent,
              */

              //backgroundImage: NetworkImage('images'),
              backgroundColor: Colors.transparent,
            ),
      accountName: Row(
        children: [
          const Text(
            'คุณ',
            style: TextStyle(
              fontFamily: 'THSarabunNew',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              //color: const Color(0xFF000120),
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'fname',
            style: TextStyle(
              fontFamily: 'THSarabunNew',
              fontSize: 20,
              fontWeight: FontWeight.normal,
              //color: const Color(0xFF000120),
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
      accountEmail: Row(
        children: [
          const Text(
            'อีเมล',
            style: TextStyle(
              fontFamily: 'THSarabunNew',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              //color: const Color(0xFF000120),
              color: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'email',
            style: TextStyle(
              fontFamily: 'THSarabunNew',
              fontSize: 20,
              fontWeight: FontWeight.normal,
              //color: const Color(0xFF000120),
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  */
  Column blocklogout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: ListTile(
            onTap: () async {
              // await FirebaseAuth.instance.signOut().then((value) {
              //   Get.offAll(const AuthenticationPage());
              // });
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

  Future<Null> findUserLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event!.uid;
        print('uid ===>> $uid');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {});
        });
      });
    });
  }

  //
  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('assets/images/pro901.jpg'), fit: BoxFit.cover),
      ),

      /*   currentAccountPicture: userModel == null
          ? Image.asset('assets/images/avatar.png')
          : const CircleAvatar(
              radius: 30.0,

              //backgroundImage: NetworkImage(userModel.images),
              
/*               backgroundImage:
                    NetworkImage("${snapshot.data.hitsList[index].images}"),
                backgroundColor: Colors.transparent, */
              

              /* backgroundImage: NetworkImage('images'),
              backgroundColor: Colors.transparent, */
            ), */

      // accountName: Row(
      //   children: [
      //      ConfigText(
      //       lable: 'คุณ',
      //       textStyle: StyleProjects().contentstyle1,
      //     ),
      //     StyleProjects().boxwidth1,
      //     StyleProjects().topicaccount(fname == null ? 'fname' : fname!),
      //   ],
      // ),

      accountName: Text('data'),

      accountEmail: Row(
        children: [
          ConfigText(
            lable: 'อีเมล',
            textStyle: StyleProjects().contentstyle7,
          ),
          StyleProjects().boxwidth2,
          StyleProjects().topicaccount2(email == null ? 'email' : email!),
          /*  Text(
            "อีเมล : ${userModels[index].email}",
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleProjects().contentstyle5,
          ), */
        ],
      ),
    );
  }

  //
}
